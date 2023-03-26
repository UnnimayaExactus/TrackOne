import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Weather {
  final String locationName;
  final String iconUrl;
  final double temperature;
  final String description;

  Weather({
    required this.locationName,
    required this.iconUrl,
    required this.temperature,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    final iconCode = weather['icon'];
    final iconUrl = 'https://openweathermap.org/img/w/$iconCode.png';
    final temperature = main['temp'];
    final description = weather['description'];
    final locationName = json['name'];
    final condition = json['weather'][0]['id'];
    return Weather(
        locationName: locationName,
        iconUrl: iconUrl,
        temperature: temperature,
        description: description);
  }
  static Future<Weather> fetch(double latitude, double longitude) async {
    final url =
        'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=21d6e175e99da7893408f2c0d5f60fdc&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
