import 'package:deneme_flutter/bildirimler/bildirim_kutucuk.dart';
import 'package:deneme_flutter/bilesenler/haberler.dart';
import 'package:flutter/material.dart';


class BildirimEkran extends StatefulWidget {
  const BildirimEkran({super.key});

  @override
  State<BildirimEkran> createState() => _BildirimEkranState();
}

class _BildirimEkranState extends State<BildirimEkran> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        centerTitle: true,

      ),
      body: ListView(
        children: [
          BildirimKutucuk(),
        ],
      ),
    );
  }
}


