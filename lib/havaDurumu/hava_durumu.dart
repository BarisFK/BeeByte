import 'package:deneme_flutter/havaDurumu/hava_durumu_gunluk.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'hava_durumu_model.dart';

class HavaDurumu extends StatefulWidget {
  const HavaDurumu({Key? key}) : super(key: key);

  @override
  State<HavaDurumu> createState() => _HavaDurumuState();
}

class _HavaDurumuState extends State<HavaDurumu> {
  WeatherService weatherService = WeatherService('8e5a13212b1a4bc08ac170917243004');
  Weather weather = Weather(temperatureC: 0, condition: 'Sunny');

  String currentWeather = "";
  double tempC = 0;

  String animasyon() {
    switch (currentWeather) {
      case 'Partly cloudy':
      case 'Cloudy':
        return 'assets/hava/bulutlu.json';
      case 'Sunny':
        return "assets/hava/gunesli.json";
      case 'Light rain':
      case 'Rain':
        return "assets/hava/yagmurlu.json";
      case 'Heavy rain':
        return "assets/hava/gokGurultulu.json";
      default:
        return "assets/hava/gunesli.json";
    }
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  void getWeather() async {
    try {
      Weather currentWeatherData = await weatherService.getCurrentWeather("Kocaeli");
      setState(() {
        weather = currentWeatherData;
        currentWeather = weather.condition;
        tempC = weather.temperatureC;
      });
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  void onTap() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // Ekranın %80'ini kaplar
          child: ThreeDayForecast(),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 120,
                width: 150,
                child: Lottie.asset(animasyon()),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kocaeli',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Sıcaklık',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  '${tempC.toInt()} C',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
