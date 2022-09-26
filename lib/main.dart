import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'gps_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(580, 890),
        builder: (c, w) => MaterialApp(
              title: 'Tafuta GPS',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              builder: (context, widget) {
                return MediaQuery(
                  //Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
                  child: widget!,
                );
              },
              home: const GPSFinder(),
            ));
  }
}
