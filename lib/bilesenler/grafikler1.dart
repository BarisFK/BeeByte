import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Grafikler1 extends StatefulWidget {
  const Grafikler1({Key? key}) : super(key: key);

  @override
  _Grafikler1State createState() => _Grafikler1State();
}

class _Grafikler1State extends State<Grafikler1> {
  int touchedIndex = -1;
  late List<Color> sectionColors; // Renkleri saklamak için bir liste
  late Map<String, List<int>> _productToSizes;

  @override
  void initState() {
    super.initState();
    sectionColors = List.generate(20, (index) => getRandomColor()); // Renkleri burada oluştur
    _fetchData(); // Veri alma işlemini initState içinde çağır
  }

  void _fetchData() async {
    Map<String, List<int>> productToSizes = await getFieldSizesByProduct(FirebaseAuth.instance.currentUser!.email!);
    setState(() {
      _productToSizes = productToSizes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _productToSizes != null
        ? _buildChart()
        : Center(child: CircularProgressIndicator());
  }

  Widget _buildChart() {
    List<PieChartSectionData> sections = [];
    int colorIndex = 0; // Renkler için bir index

    _productToSizes.forEach((tarlaUrun, tarlaBuyuklukler) {
      int totalSize = tarlaBuyuklukler.reduce((a, b) => a + b);
      sections.add(
        PieChartSectionData(
          value: totalSize.toDouble(),
          title: tarlaUrun,
          color: sectionColors[colorIndex % sectionColors.length], // Renkleri burada kullan
          radius: touchedIndex == sections.length ? 90 : 70,
        ),
      );
      colorIndex++; // Renk index'ini artır
    });

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              touchedIndex = -1;
            } else {
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            }
          });
        }),
        sections: sections,
        sectionsSpace: 0,
        centerSpaceRadius: 70,
        startDegreeOffset: 180,
      ),
    );
  }

  Future<Map<String, List<int>>> getFieldSizesByProduct(String kullaniciEposta) async {
    Map<String, List<int>> productToSizes = {};

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tarlalar')
          .where('kullaniciEmail', isEqualTo: kullaniciEposta)
          .get();

      querySnapshot.docs.forEach((doc) {
        String tarlaUrun = doc['tarlaUrun'];
        int tarlaBuyukluk = doc['tarlaBuyukluk'];

        if (!productToSizes.containsKey(tarlaUrun)) {
          productToSizes[tarlaUrun] = [];
        }

        productToSizes[tarlaUrun]!.add(tarlaBuyukluk);
      });

      return productToSizes;
    } catch (e) {
      print('Hata: $e');
      return {}; // Hata durumunda boş bir map döndür
    }
  }

  // Rastgele renk döndüren yardımcı bir fonksiyon
  Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}
