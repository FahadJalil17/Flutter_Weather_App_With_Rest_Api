// To parse this JSON data, do
//
//     final currentWeatherData = currentWeatherDataFromJson(jsonString);

import 'dart:convert';

CurrentWeatherData currentWeatherDataFromJson(String str) => CurrentWeatherData.fromJson(json.decode(str));

class CurrentWeatherData {
  List<Weather>? weather;
  Main? main;
  Wind? wind;
  Clouds? clouds;
  int? dt;
  String? name;

  CurrentWeatherData({
    this.weather,

     this.main,

     this.wind,
     this.clouds,
     this.dt,

    this.name,
  });

  factory CurrentWeatherData.fromJson(Map<String, dynamic> json) => CurrentWeatherData(

    weather: List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),

    main: Main.fromJson(json["main"]),

    wind: Wind.fromJson(json["wind"]),
    clouds: Clouds.fromJson(json["clouds"]),
    dt: json["dt"],
    name: json["name"],
  );

}

class Clouds {
  int? all;

  Clouds({
     this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
    all: json["all"],
  );

  Map<String, dynamic> toJson() => {
    "all": all,
  };
}


class Main {
  int? temp;
  int? tempMin;
  int? tempMax;
  int? humidity;


  Main({
     this.temp,
     this.tempMin,
     this.tempMax,
     this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
    temp: json["temp"]?.toInt(),
    tempMin: json["temp_min"]?.toInt(),
    tempMax: json["temp_max"]?.toInt(),
    humidity: json["humidity"],
  );

}


class Weather {
  String? main;
  String? icon;

  Weather({
     this.main,
     this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    main: json["main"],
    icon: json["icon"],
  );

}

class Wind {
  double? speed;
  int? deg;

  Wind({
     this.speed,
     this.deg,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
    speed: json["speed"]?.toDouble(),
    deg: json["deg"],
  );

  Map<String, dynamic> toJson() => {
    "speed": speed,
    "deg": deg,
  };
}
