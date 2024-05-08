import 'package:deneme_flutter/bilesenler/grafikler1.dart';
import 'package:deneme_flutter/bilesenler/grafikler2.dart';
import 'package:deneme_flutter/bilesenler/haberler.dart';
import 'package:deneme_flutter/havaDurumu/hava_durumu.dart';
import 'package:flutter/material.dart';

class AnaMenuList extends StatefulWidget {
  const AnaMenuList({super.key});

  @override
  State<AnaMenuList> createState() => _AnaMenuListState();
}

class _AnaMenuListState extends State<AnaMenuList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9,vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.green[300],),
              height: 140,
              width: 270,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: HavaDurumu()
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
          Haber(),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),color: Colors.blueGrey[200]),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Genel Veriler',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.blueGrey[100],
            ),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('Ekilen Ürünler', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 300,
                      height: 300,
                      child: Grafikler1(),
                      )
                  ),
                Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Center(
                    child: Text('Yıllara Göre Tarla Sayısı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ),
                Center(
                    child: Container(
                      width: 500,
                      height: 200,
                      child: Grafikler2(),
                    )
                ),
                SizedBox(height: 20)
              ],
            ),
          ),

        ],
      ),
    );

  }
}
