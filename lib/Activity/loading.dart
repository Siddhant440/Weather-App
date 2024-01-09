import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'worker.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String? city;
  String? temperature;
  String? humidity;
  String? windSpeed;
  String? condition;
  String? main;
  String? icon;

  Future<String?> getCurrentLocation() async {
    try {
      // Check if the location permission is granted
      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

        // Assuming you want to use the city from the first placemark
        String city = placemarks.first.locality ?? "Unknown City";
        return city;
      } else {
        // Handle the case when the user denies location permission
        print("Location permission denied");
        return null;
      }
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  void startApp(String? city) async {
    if (city != null) {
      Worker instance = Worker(location: city);

      await instance.getData();

      temperature = instance.temp;
      humidity = instance.humid;
      condition = instance.cond;
      windSpeed = instance.wind;
      main = instance.mainDes;
      icon = instance.icon;

      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          "temp_value": temperature,
          "humid_value": humidity,
          "cond_value": condition,
          "wind_value": windSpeed,
          "main_value": main,
          "icon_value": icon,
          "city_value": city,
        });
      });
    } else {
      // Handle the case when city is null
      print("City is null");
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the method to get the current location
    getCurrentLocation().then((String? currentCity) {
      setState(() {
        city = currentCity;
      });
      // Only start the app if the city is not null
      if (city != null) {
        startApp(city!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map? search = ModalRoute.of(context)?.settings.arguments as Map?;

    if (search?.isNotEmpty ?? false) {
      city = search?['searchText'];
      startApp(city);
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/weather.png", height: 210, width: 310,),
              Text("Weather App", style: GoogleFonts.inter(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),),
              SizedBox(height: 15,),
              Text("Made by Siddhant Bisht", style: GoogleFonts.inter(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),
              SizedBox(height: 100,),
              SpinKitChasingDots(
                color: Colors.white,
                size: 50,
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue[300],
    );
  }
}
