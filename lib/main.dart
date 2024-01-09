import 'package:flutter/material.dart';
import 'Activity/home.dart';
import 'Activity/loading.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home : const Loading(),
    routes : {
      "/home" : (context) => const Home(),
      "/loading" : (context) => const Loading()
    }
  ));
}
