import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:weather/consts/strings.dart';
import 'package:weather/controllers/main_controller.dart';
import 'package:weather/models/current_weather_model.dart';

import '../consts/colors.dart';
import '../consts/images.dart';
import '../services/api_services.dart';  // this package is used for formatting date

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // for showing date // and intl package is used for formatting
    // var date = DateTime.now();
    var date = DateFormat("yMMMMd").format(DateTime.now());
    var theme = Theme.of(context);  // storing app theme in theme variable

    var controller = Get.put(MainController());

    return Scaffold(
      // we want to use theme color as background color
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: date.text.color(theme.primaryColor).make(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(() =>
            IconButton(onPressed: (){
              controller.changeTheme();
            }, icon: Icon(controller.isDark.value ? Icons.light_mode : Icons.dark_mode, color: theme.iconTheme.color,)),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: theme.iconTheme.color,)),
        ],
      ),
      body: Obx(() =>
       controller.isLoaded.value == true ? Container(
          padding: EdgeInsets.all(12),
          child: FutureBuilder(
            // future: getCurrentWeather(),
            future: controller.currentWeatherData, // now UI will not create again and again
            builder: (context,AsyncSnapshot snapshot){
              if(snapshot.hasData){

                // CurrentWeatherData data = snapshot.data;  // variable of type CurrentWeatherData which is model class

                return  SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "${snapshot.data.name}".text.uppercase.fontFamily("poppins_bold").size(32).letterSpacing(2).color(theme.primaryColor).make(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/weather/${snapshot.data.weather![0].icon}.png", width: 80, height: 80,),
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "${snapshot.data.main.temp}", style: TextStyle(
                                    color: theme.primaryColor, fontSize: 64, fontFamily: 'poppins'
                                )
                                ),
                                TextSpan(
                                    text: "  ${snapshot.data.weather![0].main}", style: TextStyle(
                                    color: theme.primaryColor, fontSize: 14, fontFamily: "poppins"
                                )
                                )

                              ]
                          ))
                        ],
                      ),

                      // for showing how much temperature can go high or low
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(onPressed: null,
                              icon: Icon(Icons.expand_less_rounded, color: theme.iconTheme.color,),
                              label: "${snapshot.data.main!.tempMax}$degree".text.color(theme.iconTheme.color).make()),
                          TextButton.icon(onPressed: null,
                              icon: Icon(Icons.expand_more_rounded, color: theme.iconTheme.color,),
                              label: "${snapshot.data.main!.tempMin}$degree".text.color(theme.iconTheme.color).make())
                        ],
                      ),
                      10.heightBox,

// for showing cloud percent, wind speed and humidity and their values
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(3, (index){
                          var iconsList = [clouds, humidity, windspeed];
                          var values = ["${snapshot.data.clouds!.all}", "${snapshot.data.main!.humidity}", "${snapshot.data.wind!.speed} km/h"];
                          return Column(
                            children: [
                              Image.asset(iconsList[index], width: 60, height: 60,).box.gray200.padding(EdgeInsets.all(8)). roundedSM.make(),
                              10.heightBox,
                              "${values[index]}".text.gray400.make(),
                            ],
                          );
                        }),
                      ),

                      10.heightBox,
                      Divider(),
                      10.heightBox,

                      // using 2nd future builder for getting hourly data
                      FutureBuilder(
                          future: controller.hourlyWeatherData,
                          builder: (context, AsyncSnapshot snapshot){
                            if(snapshot.hasData){
                              return SizedBox(
                                height: 150,
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.list!.length > 6 ? 6 : snapshot.data.list!.length,
                                    itemBuilder: (context, index){
                                      // time is in dt format in api
                                      var time = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.list![index].dt!.toInt() * 1000));

                                      return Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            time.text.gray200.make(),
                                            Image.asset("assets/weather/${snapshot.data.list![index].weather![0].icon}.png",  width: 80,),
                                            "${snapshot.data.list![index].main!.temp}$degree".text.white.make()
                                          ],
                                        ),
                                      );
                                    }),
                              );
                            }
                            else{
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                      }),

                      10.heightBox,
                      Divider(),
                      10.heightBox,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Next 7 Days".text.semiBold.size(16).color(theme.primaryColor).make(),
                          TextButton(onPressed: (){}, child: "View All".text.make())
                        ],
                      ),

                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (context,  index){

                            var day = DateFormat("EEEE").format(DateTime.now().add(Duration(days: index + 1)));

                            return Card(
                              color: theme.cardColor,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: day.text.semiBold.color(theme.primaryColor).make()),
                                    Expanded(
                                      child: TextButton.icon(onPressed: null,
                                          icon: Image.asset('assets/weather/50n.png', width: 40,),
                                          label: "26$degree".text.color(theme.primaryColor).make()),
                                    ),
                                    // "38$degree / 24$degree".text.make(),
                                    RichText(text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "37$degree /",
                                              style: TextStyle(
                                                  fontFamily: "poppins",
                                                  fontSize: 16,
                                                  color: theme.primaryColor
                                              )
                                          ),

                                          TextSpan(
                                              text: " 24$degree",
                                              style: TextStyle(
                                                fontFamily: "poppins",
                                                fontSize: 16,
                                                color: theme.iconTheme.color,
                                              )
                                          ),

                                        ]
                                    ))
                                  ],
                                ),
                              ),
                            );
                          })



                    ],
                  ),
                );
              }
              else{
                return Center(child: CircularProgressIndicator());
              }

            },

          )
        )
           :
           Center(
             child: CircularProgressIndicator(),
           )
      ),
    );
  }
}

