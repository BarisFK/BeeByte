import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'hava_durumu_model.dart';

class ThreeDayForecast extends StatefulWidget {
  const ThreeDayForecast({Key? key}) : super(key: key);

  @override
  _ThreeDayForecastState createState() => _ThreeDayForecastState();
}

class _ThreeDayForecastState extends State<ThreeDayForecast> {
  WeatherService weatherService = WeatherService('8e5a13212b1a4bc08ac170917243004');
  late List<Forecast> forecasts = [];

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  void fetchForecast() async {
    try {
      List<Forecast> forecastData = await weatherService.getThreeDayForecast("Kocaeli");
      setState(() {
        forecasts = forecastData;
      });
    } catch (e) {
      print("Error fetching forecast: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3 Günlük Hava Durumu'),
        centerTitle: true,
      ),
      body: forecasts != null
          ? ListView.builder(
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(50,10,5,10),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: Lottie.asset(animasyon(forecasts[index].condition)),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarih: ${forecasts[index].date}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Maksimum Sıcaklık: ${forecasts[index].maxTemperatureC} C',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Minimum Sıcaklık: ${forecasts[index].minTemperatureC} C',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Durum: ${forecasts[index].condition}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String animasyon(String condition) {
    switch (condition) {
      case 'Cloudy':
        return 'assets/hava/bulutlu.json';
      case 'Sunny':
        return "assets/hava/gunesli.json";
      case 'Light rain':
        return "assets/hava/yagmurlu.json";
      case 'Moderate rain':
        return "assets/hava/yagmurlu.json";
      case 'Rain':
        return "assets/hava/yagmurlu.json";
      case 'Heavy rain':
        return "assets/hava/gokGurultulu.json";
      case 'Patchy rain nearby':
        return "assets/hava/yagmurlu.json";
      default:
        return "assets/hava/gunesli.json";
    }
  }
}
