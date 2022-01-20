import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: "OpenSans",
  primarySwatch: Colors.orange,
  textTheme: TextTheme(),
  scaffoldBackgroundColor: Colors.grey.shade50,
  appBarTheme: AppBarTheme(
    // titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    // iconTheme: IconThemeData(color: Colors.white),
  ),
);
final ThemeData darkTheme = ThemeData(
  fontFamily: "OpenSans",
  primarySwatch: Colors.orange,
);

Widget buildAppLogo([int size = 14]) {
  return Text(
    "Recipeshare",
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: size.toDouble(),
      fontWeight: FontWeight.bold,
      color: Get.theme.primaryColor,
      fontStyle: FontStyle.italic,
    ),
  );
}
