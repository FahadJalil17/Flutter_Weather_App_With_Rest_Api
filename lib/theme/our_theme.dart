import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';

class CustomThemes{
   static final lightTheme = ThemeData(
     fontFamily: "poppins",
     scaffoldBackgroundColor: Colors.white,
     primaryColor: Vx.gray800,
     cardColor: Colors.white,
     iconTheme: IconThemeData(
       color: Vx.gray600,
     )
   );

   // for dark theme
static final darkTheme = ThemeData(
  fontFamily: "poppins",
  scaffoldBackgroundColor: bgColor,
  primaryColor: Colors.white,
  cardColor: bgColor.withOpacity(0.6),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
);

}