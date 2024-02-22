import 'package:flutter/material.dart';
import 'package:weather_forecast_app/weather_home_page.dart';


void main(List<String> args) {
  runApp(const WeatherForecastApp());
}

class WeatherForecastApp extends StatelessWidget {
  const WeatherForecastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WeatherHomePage(),
    );
  }
}
