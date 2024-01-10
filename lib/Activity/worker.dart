import 'package:http/http.dart';
import 'dart:convert';

class Worker {
  String location;

  Worker({required this.location})
  {
    location = location;
  }

  String? temp;
  String? humid;
  String? wind;
  String? cond;
  String? icon;
  String? mainDes;
  Future<void> getData() async {
    try {
      Response response = await get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=17445f1790476b4fe8d8d7f489f5f52c"));

      Map data = jsonDecode(response.body);

      print(data);

      // for condition
      List weather_data_map = data['weather'];
      Map weather_main_data_map = weather_data_map[0];
      String con = weather_main_data_map['description'];
      String mai = weather_main_data_map['main'];

      // for temperature
      Map temp_data_map = data['main'];
      double tem = temp_data_map['temp'] - 273.15;

      // for wind speed
      Map wind_data_map = data['wind'];
      double win = wind_data_map['speed'] / 0.27777777777778;

      // for humidity
      String hum = temp_data_map['humidity'].toString();

      // assigning values
      temp = tem.toString();
      wind = win.toString();
      humid = hum.toString();
      cond = con;
      mainDes = mai;
      icon = weather_main_data_map["icon"].toString();
    }
    catch (e)
    {
      temp = "N/A";
      wind = "N/A";
      humid = "N/A";
      cond = "Can't find the data";
      mainDes = "N/A";
      icon = "03n";
    }
  }
}
