import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/current_weather_model.dart';

import '../consts/strings.dart';
import '../models/hourly_weather_model.dart';

// for current weather
// var link = "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

// var hourlyLink = "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

getCurrentWeather(lat, long) async{
var link = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var response = await http.get(Uri.parse(link));

  if(response.statusCode == 200){
    var data = currentWeatherDataFromJson(response.body.toString());  // this func is decoding json // from model class
    return data;
  }
}

getHourlyWeather(lat, long) async{
  var hourlyLink = "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var response = await http.get(Uri.parse(hourlyLink));

  if(response.statusCode == 200){
    var data = hourlyWeatherDataFromJson(response.body.toString());
    debugPrint("Hourly Data is received");
    return data;
  }
}


