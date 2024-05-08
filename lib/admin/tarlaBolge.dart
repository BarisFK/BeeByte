import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarlaBolgeEkle extends StatelessWidget {
  final String tarlaAdi;

  TarlaBolgeEkle({required this.tarlaAdi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarla Bölge Ekle'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('Tarlalar').doc(this.tarlaAdi).collection('tarlaBolgeleri').doc('bolge1').set({
              'azotOrani1': 70,
              'azotOrani2': 80,
              'azotOrani3': 90,
              'azotOrani4': 92,
              'azotOrani5': 60,
              'azotOrani6': 50,
              'azotOrani7': 98,
              'azotOrani8': 37,
              'azotOrani9': 68,
              'havaOrani1': 60,
              'havaOrani2': 70,
              'havaOrani3': 57,
              'havaOrani4': 53,
              'havaOrani5': 77,
              'havaOrani6': 66,
              'havaOrani7': 59,
              'havaOrani8': 54,
              'havaOrani9': 69,
              'olgunluk1': 50,
              'olgunluk2': 39,
              'olgunluk3': 70,
              'olgunluk4': 60,
              'olgunluk5': 10,
              'olgunluk6': 26,
              'olgunluk7': 80,
              'olgunluk8': 59,
              'olgunluk9': 95,
              'suOrani1': 50,
              'suOrani2': 49,
              'suOrani3': 48,
              'suOrani4': 51,
              'suOrani5': 52,
              'suOrani6': 49,
              'suOrani7': 48,
              'suOrani8': 50,
              'suOrani9': 47,
            }).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Veriler aktarıldı')),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Veri aktarımında hata oluştu: $error')),
              );
            });
          },
          child: Text('Aktar'),
        ),
      ),
    );
  }
}
