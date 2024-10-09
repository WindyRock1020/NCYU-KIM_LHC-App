import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ncyu_kim_lhc/homePage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2400),
      builder: (context, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          title: "NCYU_KIM_LHC",
          theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: const Color(0xff7392ff),
              scaffoldBackgroundColor: const Color(0xfff7f7f7),
              appBarTheme: const AppBarTheme(
                color: Color(0xff7392ff),
                iconTheme: IconThemeData(color: Color(0xff333333)),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xff333333)),
                bodyMedium: TextStyle(color: Color(0xff333333)),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xff7392ff)), //button color
                  foregroundColor: WidgetStateProperty.all<Color>(const Color(0xffffffff)), //text (and icon)
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(const Color(0xff7392ff)), //button color
                ),
              )
          ),
          home: const HomePage(),
        );
      }
    );
  }
}
