import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tafuta_gps/controllers/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GPSFinder extends StatefulWidget {
  const GPSFinder({Key? key}) : super(key: key);

  @override
  State<GPSFinder> createState() => _GPSFinderState();
}

class _GPSFinderState extends State<GPSFinder> {
  final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 65.0, left: 20.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Text(
                  'My Location',
                  style: TextStyle(
                      color: Color.fromRGBO(25, 40, 81, 1),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins'),
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    size: 34.0,
                  ),
                  onPressed: () async {
                    await locationController.locationPermissions();
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 110.0, right: 20.0, left: 20.0),
            child: Obx(() {
              return ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  locationController.showLoader.value
                      ? const LinearProgressIndicator()
                      : Container(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    color: Color.fromRGBO(240, 239, 239, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: <Widget>[
                        Text('Format:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Decimal Degrees',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins'),
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Obx(() {
                      return Column(
                        children: [
                          ReadingBox(
                              title: 'Latitude',
                              readingValue: locationController.latitude.value),
                          SizedBox(
                            height: 10.0,
                          ),
                          ReadingBox(
                              title: 'Longitude',
                              readingValue: locationController.longitude.value),
                        ],
                      );
                    }),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Divider(
                    thickness: 5.0,
                    color: Color.fromRGBO(37, 95, 166, 1),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    color: Color.fromRGBO(240, 239, 239, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: <Widget>[
                        Text('Format:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                            'UTM (Universal Transverse Mercator)',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins'),
                          ),
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Obx(() {
                      return Column(
                        children: [
                          ReadingBox(title: 'UTM Zone', readingValue: '36N'),
                          SizedBox(
                            height: 10.0,
                          ),
                          ReadingBox(
                              title: 'Eastings',
                              readingValue: locationController.easting.value),
                          SizedBox(
                            height: 10.0,
                          ),
                          ReadingBox(
                              title: 'Northings',
                              readingValue: locationController.northing.value),
                        ],
                      );
                    }),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Divider(
                    thickness: 5.0,
                    color: Color.fromRGBO(37, 95, 166, 1),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Obx(() {
                        return Column(children: [
                          ReadingBox(
                              title: 'Elevation / Altitude (in meters)',
                              readingValue: locationController.elevation.value),
                        ]);
                      })),
                  SizedBox(
                    height: 15.h,
                  ),
                  Divider(
                    thickness: 5.0,
                    color: Color.fromRGBO(37, 95, 166, 1),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Obx(() {
                        return Column(children: [
                          ReadingBox(
                              title: 'Coordinates Accuracy',
                              readingValue:
                                  '${locationController.accuracy.value.round()} m'),
                        ]);
                      })),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ReadingBox extends StatelessWidget {
  const ReadingBox({
    Key? key,
    required this.title,
    required this.readingValue,
  }) : super(key: key);

  final readingValue;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins'),
        ),
        SizedBox(
          height: 6.h,
        ),
        Container(
            height: 60.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(border: Border.all()),
            child: Row(
              children: [
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  '${readingValue}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 30.sp,
                    color: const Color(0xFF929292),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
