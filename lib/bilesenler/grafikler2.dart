import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Grafikler2 extends StatefulWidget {
  const Grafikler2({Key? key}) : super(key: key);

  @override
  _Grafikler2State createState() => _Grafikler2State();
}

class _Grafikler2State extends State<Grafikler2> {
  late List<FlSpot> _dataSpots;

  @override
  void initState() {
    super.initState();
    _dataSpots = [];
    _fetchDataFromFirestore();
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tarlalar')
          .where('kullaniciEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
          .get();

      Map<int, int> yearCountMap = {}; // Yıl bazında tarla sayacı

      querySnapshot.docs.forEach((doc) {
        DateTime? ekimTarihi = (doc['ekimTarihi'] as Timestamp?)?.toDate();
        if (ekimTarihi != null) {
          int year = ekimTarihi.year % 100; // Yılın son iki rakamını al
          if (yearCountMap.containsKey(year)) {
            yearCountMap[year] = yearCountMap[year]! + 1;
          } else {
            yearCountMap[year] = 1;
          }
        }
      });

      // Yıllara göre tarla sayılarını FlSpot listesine dönüştür
      List<FlSpot> spots = [];
      yearCountMap.forEach((year, count) {
        spots.add(FlSpot(year.toDouble(), count.toDouble()));
      });

      setState(() {
        _dataSpots = spots;
      });

    } catch (e) {
      print('Veri alınırken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 5,

        // Veriye göre maksimum yükseklik belirlenmeli
        gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: true),
        titlesData:  FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
          ),

        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black, width: 0.8)),
        lineBarsData: [
          LineChartBarData(
            spots: _dataSpots,
            isCurved: true,
            color: Colors.lightGreen, // Tek bir renk belirtilmeli
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: Colors.lightGreen),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return LineTooltipItem(
                  '${touchedSpot.x.toInt()}: ${touchedSpot.y.toInt()} tarla',
                  TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
