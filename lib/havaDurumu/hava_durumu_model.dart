import 'dart:convert';

import 'package:http/http.dart' as http;

class Weather {
  final double temperatureC;
  final String condition;

  Weather({
    required this.temperatureC,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperatureC: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
    );
  }
}

class Forecast {
  final String date;
  final double maxTemperatureC;
  final double minTemperatureC;
  final String condition;

  Forecast({
    required this.date,
    required this.maxTemperatureC,
    required this.minTemperatureC,
    required this.condition,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['date'],
      maxTemperatureC: json['day']['maxtemp_c'],
      minTemperatureC: json['day']['mintemp_c'],
      condition: json['day']['condition']['text'],
    );
  }
}


class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getCurrentWeather(String place) async {
    try {
      final queryParameters = {
        'key': apiKey,
        'q': place,
      };
      final uri = Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Can not get current weather");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Forecast>> getThreeDayForecast(String place) async {
    try {
      final queryParameters = {
        'key': apiKey,
        'q': place,
        'days': '3',
      };
      final uri = Uri.http('api.weatherapi.com', '/v1/forecast.json', queryParameters);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> forecastData = data['forecast']['forecastday'];
        return forecastData
            .map((forecastJson) => Forecast.fromJson(forecastJson))
            .toList();
      } else {
        throw Exception("Can not get forecast");
      }
    } catch (e) {
      rethrow;
    }
  }
}
