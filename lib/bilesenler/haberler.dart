import 'package:deneme_flutter/bilesenler/haberler_detay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Haber extends StatelessWidget {
  const Haber({Key? key});

  @override
  Widget build(BuildContext context) {
    late String baslik;
    late int index1;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
              decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),color: Colors.blueGrey[200]),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Haber Akışı',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 300,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                if (index == 1) {
                  baslik = 'Yerli Traktörler Uluslararası Ödüle Layık Görüldü';
                  index1 = 1;
                } else if (index == 0) {
                  baslik = 'Tarımsal Destekler Çiftçinin Yüzünü Güldürdü';
                  index1 = 0;
                } else {
                  baslik = 'Yenilikçi Tarım Teknolojileriyle Verimlilik Artıyor';
                  index1 = 2;
                }
                return Container(
                  height: 380,
                  width: 380,
                  decoration: BoxDecoration(color: Colors.blueGrey[100]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/haber/h$index.jpeg',
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HaberDetay(index: index1)),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$baslik',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: 35,
            decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),color: Colors.blueGrey[200]),
          )
        ],
    );
  }
}
