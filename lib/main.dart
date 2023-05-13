import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/theme/our_theme.dart';
import 'package:weather/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      themeMode: ThemeMode.system, // according to the system application will be run in that mode for the first time
      home: HomeScreen(),
    );
  }
}

