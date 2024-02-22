import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/additional_info_item.dart';
import 'package:weather_forecast_app/hourly_weather_forecast.dart';
import 'package:weather_forecast_app/secrets.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  // getting response from the web
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Bhilwara";
      final weatherRes = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$getWeatherAPIKey"));
      final data = jsonDecode(weatherRes.body);
      if (data["cod"] != 200) {
        throw "An unexpected error occured";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  // second future
  Future<Map<String, dynamic>> getHourlyForecast() async {
    try {
      String cityName = "Bhilwara";
      final forecastRes = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$getWeatherAPIKey"));
      final data1 = jsonDecode(forecastRes.body);
      if (data1["cod"] != "200") {
        throw "An unexpected error occured";
      }
  
      return data1;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        centerTitle: true,
        title: const Text(
          "Weather Forecast",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          // Values for specific information
          final data = snapshot.data!;
          final dataAtMain = data["main"];
          final currentTemprature = dataAtMain["temp"];
          final currentSky = data["weather"][0]["main"];
          final currentDescription = data["weather"][0]["description"];
          final currentHumidity = dataAtMain["humidity"];
          final currentPressure = dataAtMain["pressure"];
          final currentWindSpeed = data["wind"]["speed"];

          // Current Weather Icon Data
          IconData currentWeatherIcon;

          if (currentSky == "Rain") {
            currentWeatherIcon = Icons.cloudy_snowing;
          } else if (currentSky == "Sunny") {
            currentWeatherIcon = Icons.sunny;
          } else {
            currentWeatherIcon = Icons.cloud;
          }

          // Widget Tree starts from here
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Text(
                                "${(currentTemprature - 273.15).round()} °C",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Icon(
                                currentWeatherIcon,
                                size: 50,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                currentDescription,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),

                //weather forecast cards
                const Text(
                  "Hourly Weather Forecast",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              

                FutureBuilder(
                    future: getHourlyForecast(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }

                      final data1 = snapshot.data;

                      return SizedBox(
                        height: 131,
                        child: ListView.builder(
                            itemCount: 9,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final timeText = data1!["list"][index]["dt_txt"];
                              final value =
                                  data1["list"][index]["main"]["temp"];
                              final hourlySky =
                                  data1["list"][index]["weather"][0]["main"];

                              final IconData hourlyWeatherIcon;
                              if (hourlySky == "Rain") {
                                hourlyWeatherIcon = Icons.cloudy_snowing;
                              } else if (hourlySky == "Sunny") {
                                hourlyWeatherIcon = Icons.sunny;
                              } else {
                                hourlyWeatherIcon = Icons.cloud;
                              }

                              final time = DateTime.parse(timeText);

                              return HourlyForecastItem(
                                  timeText: DateFormat.j().format(time),
                                  value: "${(value - 273.15).round()} °C",
                                  icon: hourlyWeatherIcon);
                            }),
                      );
                    }),

                const SizedBox(
                  height: 30,
                ),

                //additional information
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: currentHumidity.toDouble()),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: currentWindSpeed,
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: currentPressure.toDouble(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
