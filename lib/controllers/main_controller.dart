import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/services/api_services.dart';

class MainController extends GetxController{
  // like in stateful widget we have initstate method in getX we have onInit which works like init
  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    await getUserLocation();
    // this variable is equal to function this means when app will be open this function will be executed only one time
    // we will use it in future in homescreen
    currentWeatherData = getCurrentWeather(latitude.value, longitude.value);
    // Now we have to call to functions in future builder
    hourlyWeatherData = getHourlyWeather(latitude.value, longitude.value);
  }

  var isDark = false.obs;
  var currentWeatherData;
  var hourlyWeatherData;

  // for getting user location
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoaded = false.obs;

  changeTheme(){
    isDark.value = !isDark.value; // isDark is true here
    Get.changeThemeMode(isDark.value ? ThemeMode.dark  : ThemeMode.light);
  }

  getUserLocation() async{
    var isLocationEnabled;
    // if location is enabled we have to take permission from user and store it in a variable
    var userPermission;

    // for checking if permission is enabled or not
    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isLocationEnabled){ // not enabled
     return Future.error("Location is not enabled");
    }

    // if location is enabled we have to get the permission from the user
    userPermission = await Geolocator.checkPermission();
    if(userPermission == LocationPermission.deniedForever){
      return Future.error("Permission is denied forever");
    }
    else if(userPermission == LocationPermission.denied){
      userPermission = await Geolocator.requestPermission();

      if(userPermission == LocationPermission.denied){
        return Future.error("Permission is denied");
      }
    }
// if the above both conditions are not satisfied
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    ).then((value){   //  current location response will be save in this value
      latitude.value = value.latitude;
      longitude.value = value.longitude;
      isLoaded.value = true;
    });

  }

}