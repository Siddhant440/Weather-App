import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    print("This is the init state");
  }

  @override
  void setState(fn) {
    super.setState(fn);
    print("Set state is called");
  }

  @override
  void dispose() {
    super.dispose();
    print("Widget is destroyed");
  }

  @override
  Widget build(BuildContext context) {
    var cityName = ["Haldwani", "Nainital", "Kichha", "Bhimtal"];
    final random = new Random();
    var randomCity = cityName[random.nextInt(cityName.length)];

    Map? info = ModalRoute.of(context)?.settings.arguments as Map;
    String temp = ((info['temp_value']).toString());
    String wind = ((info['wind_value']).toString());

    if (temp == 'N/A') {
      print("N/A");
    } else {
      temp = ((double.parse(info['temp_value'] ?? '0')).round()).toString();
      wind = double.parse(info['wind_value'] ?? '0').toStringAsFixed(2);
    }

    String humid = (info['humid_value']);
    String cond = (info['cond_value']);
    String icon = info['icon_value'];
    String city = info['city_value'];

    String capitalizeFirstLetter(String word) {
      if (word.isEmpty) {
        return word; // return unchanged for empty strings
      }
      return word[0].toUpperCase() + word.substring(1);
    }

    String processSearchText(String text) {
      List<String> words = text.split(' ');

      for (int i = 0; i < words.length; i++) {
        if (words[i].isNotEmpty) {
          words[i] = capitalizeFirstLetter(words[i]);
        }
      }

      String processedText = words.join(' ');
      return processedText;
    }

    String condi = capitalizeFirstLetter(cond);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent.shade200,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.9],
                colors: [Colors.blue.shade400, Colors.blue.shade700])),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ("Search $randomCity or any other city"),hintStyle: GoogleFonts.inter()),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank Search");
                      } else {
                        String processedText =
                            processSearchText(searchController.text);
                        Navigator.pushNamed(context, "/loading", arguments: {
                          "searchText": processedText,
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Container 1
            Row(
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white.withOpacity(0.5)),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      padding: EdgeInsets.all(26),
                      child: Row(
                        children: [
                          Image.network(
                              "https://openweathermap.org/img/wn/$icon@2x.png"),
                          SizedBox(width: 35),
                          Column(
                            children: [
                              Text("$condi",
                                  style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              Text("in $city",
                                  style: GoogleFonts.inter(fontSize: 13))
                            ],
                          )
                        ],
                      )),
                ),
              ],
            ),

            //Container 2
            Row(
              children: [
                Expanded(
                  child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white.withOpacity(0.5)),
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      padding: EdgeInsets.all(26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(WeatherIcons.thermometer),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(" $temp°",
                                  style: GoogleFonts.inter(fontSize: 60)),
                              Text("C", style: GoogleFonts.inter(fontSize: 25))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Current Temperature",
                                    style: GoogleFonts.inter(fontSize: 13)),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),

            //Container 3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white.withOpacity(0.5)),
                    margin: EdgeInsets.fromLTRB(24, 0,7, 0),
                    padding: EdgeInsets.all(26),
                    height: 210,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Icon(WeatherIcons.day_windy)],
                        ),
                        SizedBox(height: 15),
                        Text("$wind",
                            style: GoogleFonts.inter(
                                fontSize: 30, fontWeight: FontWeight.w500)),
                        Text("KM/H",
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text("Wind Speed",
                              style: GoogleFonts.inter(fontSize: 13)),
                        )
                      ],
                    ),
                  ),
                ),

                //Container 4
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white.withOpacity(0.5)),
                    margin: EdgeInsets.fromLTRB(7, 0, 24, 0),
                    padding: EdgeInsets.all(26),
                    height: 210,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Icon(WeatherIcons.humidity)],
                        ),
                        SizedBox(height: 15),
                        Text(" $humid%",
                            style: GoogleFonts.inter(
                                fontSize: 30, fontWeight: FontWeight.w500)),
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text("Humidity",
                              style: GoogleFonts.inter(fontSize: 13)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 85),
              child: Column(
                children: [
                  Text("Made by Siddhant Bisht",
                      style: GoogleFonts.inter(fontSize: 10)),
                  Text("Data Provider : OpenWeathermap.org",
                      style: GoogleFonts.inter(fontSize: 10))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
