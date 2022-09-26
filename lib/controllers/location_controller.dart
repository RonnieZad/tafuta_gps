import 'dart:async';

import 'package:get/get.dart';
import 'package:latlong_to_osgrid/latlong_to_osgrid.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  Timer? timer;
  late LocationData locationData;
  Location location = Location();
  var isLocationEnabled = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var elevation = 0.obs;
  var accuracy = 0.0.obs;
  var easting = 0.obs;
  var northing = 0.obs;
  var coordinateAccuracy = 0.obs;
  var showLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => locationPermissions());
  }






  listenForLocationChanges() async {
    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled) {
      LatLongConverter converter = LatLongConverter();
      _serviceEnabled = await location.requestService();
      isLocationEnabled.value = _serviceEnabled;
      location.onLocationChanged.listen((LocationData currentLocation) {

        OSRef result = converter.getOSGBfromDec(
            currentLocation.latitude!, currentLocation.longitude!);

        latitude.value = currentLocation.latitude!;
        longitude.value = currentLocation.longitude!;
        elevation.value = currentLocation.altitude!.round();
        accuracy.value = currentLocation.accuracy!;
        easting.value = result.easting;
        northing.value = result.northing;
      });
    }
  }

  Future locationPermissions() async {
    showLoader(true);
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    isLocationEnabled.value = _serviceEnabled;
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      isLocationEnabled.value = _serviceEnabled;
      locationData = await location.getLocation();
      latitude.value = locationData.latitude!;
      longitude.value = locationData.longitude!;
      elevation.value = locationData.altitude!.round();
      accuracy.value = locationData.accuracy!;

      if (!_serviceEnabled) {
        isLocationEnabled.value = _serviceEnabled;
        locationData = await location.getLocation();
        latitude.value = locationData.latitude!;
        longitude.value = locationData.longitude!;
        elevation.value = locationData.altitude!.round();
        accuracy.value = locationData.accuracy!;

        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        LatLongConverter converter = LatLongConverter();

        locationData = await location.getLocation();
        OSRef result = converter.getOSGBfromDec(
            locationData.latitude!, locationData.longitude!);
        latitude.value = locationData.latitude!;
        longitude.value = locationData.longitude!;
        elevation.value = locationData.altitude!.round();
        accuracy.value = locationData.accuracy!;
        easting.value = result.easting;
        northing.value = result.northing;
        return;
      }
    }

    locationData = await location.getLocation();

    await Future.delayed(const Duration(seconds: 2));
    showLoader(false);
    LatLongConverter converter = LatLongConverter();
    OSRef result = converter.getOSGBfromDec(
        locationData.latitude!, locationData.longitude!);
    latitude.value = locationData.latitude!;
    longitude.value = locationData.longitude!;
    elevation.value = locationData.altitude!.round();
    accuracy.value = locationData.accuracy!;
    easting.value = result.easting;
    northing.value = result.northing;
    print('GPS accuracy here ${accuracy.value}');
    return locationData;
  }

  String getAccuracyReadingText() {
    if (accuracy.value < 10.0) {
      return 'High';
    } else if (accuracy.value > 10.0 && accuracy.value < 50.0) {
      return 'Moderate High';
    } else if (accuracy.value > 50.0 && accuracy.value < 100.0) {
      return 'Low';
    } else if (accuracy.value == 200.0 && accuracy.value > 200.0) {
      return 'Vey low';
    } else
      return 'Lowest';
  }

  // showLocationPrompt(BuildContext context) {
  //   final ScrollController list = ScrollController();
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20.0)),
  //           child: Padding(
  //             padding:
  //                 const EdgeInsets.only(top: 20.0, left: 14.0, right: 14.0),
  //             child: Stack(clipBehavior: Clip.none, children: <Widget>[
  //               Text(
  //                 'Opt in to use Location Background services ',
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontFamily: 'Poppins',
  //                     fontSize: 20.0,
  //                     fontWeight: FontWeight.w700),
  //               ),
  //               SizedBox(
  //                 height: 10.0,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 100.h, bottom: 65.h),
  //                 child: SizedBox(
  //                   height: 400,
  //                   child: SingleChildScrollView(
  //                     controller: list,
  //                     child: Text(
  //                       'WASSMIS collects location data about water sources and public sanitation facilities in Uganda, even when the app is closed or not in use.\n\nThis data includes key attributes about these sources and facilities including their location coordinates and government jurisdictions.\n\nThe data collected using this Application is primarily used to compute the key indicators defined under the Sustainable Development Goals (SDGs) and the Ugandan National Development Plan.\n\nThe data is also used to generate factual reports that will inform development decision making and assess development efforts towards improving the lives of the people in Uganda.  Therefore, in order to effectively do this we require the GPS coordinates which we automatically and append to the water sources and public sanitation facilities. I f you decline this, you can later turn it on under Settings/Permissions/Location',
  //                       // textAlign: TextAlign.justify,
  //                       style: TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 14.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 10.h,
  //                 right: 0.0,
  //                 left: 0.0,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Expanded(
  //                       child: ActionChip(
  //                           backgroundColor: Colors.green,
  //                           labelPadding: EdgeInsets.symmetric(
  //                               horizontal: 20.w, vertical: 3.h),
  //                           label: Text(
  //                             'Accept',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontFamily: 'Poppins',
  //                               fontSize: 16.0,
  //                             ),
  //                           ),
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                             final locationController =
  //                                 Get.put(LocationController());
  //                             locationController
  //                                 .locationPermissions()
  //                                 .then((locationData) {
  //                               print('here');
  //                               print(locationData.latitude!);
  //                               locationController.latitude.value =
  //                                   locationData.latitude!;
  //                               locationController.longitude.value =
  //                                   locationData.longitude!;
  //                               locationController.elevation.value =
  //                                   locationData.altitude!.round();
  //                               locationController.accuracy.value =
  //                                   locationData.accuracy!;
  //                               return;
  //                             });
  //                           }),
  //                     ),
  //                     SizedBox(
  //                       width: 15.0,
  //                     ),
  //                     Expanded(
  //                       child: ActionChip(
  //                           backgroundColor: Colors.red,
  //                           labelPadding: EdgeInsets.symmetric(
  //                               horizontal: 20.w, vertical: 3.h),
  //                           label: Text(
  //                             'Decline',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontFamily: 'Poppins',
  //                               fontSize: 16.0,
  //                             ),
  //                           ),
  //                           onPressed: () {
  //                             // Navigator.pop(context);
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => Pager()));
  //                           }),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ]),
  //           ),
  //         );
  //       });
  // }

}
