import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../yanMenu/notlar.dart';

class TarlaDetay extends StatefulWidget {
  final String tarlaId;

  const TarlaDetay({Key? key, required this.tarlaId}) : super(key: key);

  @override
  State<TarlaDetay> createState() => _TarlaDetayState();
}

class _TarlaDetayState extends State<TarlaDetay> {
  @override
  Widget build(BuildContext context) {
    int calculateRemainingDays(double olgunluk) {
      double initialDays = 80.0; 
      double reductionPerPercent =
          1.0; 
      double remainingDays = initialDays - (olgunluk * reductionPerPercent);
      return remainingDays.toInt().clamp(
          0, initialDays.toInt());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarla Örneği'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Tarlalar')
            .doc(widget.tarlaId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var tarlaData = snapshot.data!.data() as Map<String, dynamic>;
            String tarlaAdi = tarlaData['tarlaAdi'] ?? '';
            final timestamp = (tarlaData['ekimTarihi'] as Timestamp).toDate();
            final ekimTarihi =
                '${timestamp.day}/${timestamp.month}/${timestamp.year}';

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Tarlalar')
                  .doc(widget.tarlaId)
                  .collection('tarlaBolgeleri')
                  .doc('bolge1')
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var bolgeData = snapshot.data!.data() as Map<String, dynamic>;
                  final azotOranlari = [
                    bolgeData["azotOrani1"] ?? 0.0,
                    bolgeData["azotOrani2"] ?? 0.0,
                    bolgeData["azotOrani3"] ?? 0.0,
                    bolgeData["azotOrani4"] ?? 0.0,
                    bolgeData["azotOrani5"] ?? 0.0,
                    bolgeData["azotOrani6"] ?? 0.0,
                    bolgeData["azotOrani7"] ?? 0.0,
                    bolgeData["azotOrani8"] ?? 0.0,
                    bolgeData["azotOrani9"] ?? 0.0,
                  ];

                  final suOranlari = [
                    bolgeData["suOrani1"] ?? 0.0,
                    bolgeData["suOrani2"] ?? 0.0,
                    bolgeData["suOrani3"] ?? 0.0,
                    bolgeData["suOrani4"] ?? 0.0,
                    bolgeData["suOrani5"] ?? 0.0,
                    bolgeData["suOrani6"] ?? 0.0,
                    bolgeData["suOrani7"] ?? 0.0,
                    bolgeData["suOrani8"] ?? 0.0,
                    bolgeData["suOrani9"] ?? 0.0,
                  ];
                  final havaOranlari = [
                    bolgeData["havaOrani1"] ?? 0.0,
                    bolgeData["havaOrani2"] ?? 0.0,
                    bolgeData["havaOrani3"] ?? 0.0,
                    bolgeData["havaOrani4"] ?? 0.0,
                    bolgeData["havaOrani5"] ?? 0.0,
                    bolgeData["havaOrani6"] ?? 0.0,
                    bolgeData["havaOrani7"] ?? 0.0,
                    bolgeData["havaOrani8"] ?? 0.0,
                    bolgeData["havaOrani9"] ?? 0.0,
                  ];

                  final olgunluk = [
                    bolgeData["olgunluk1"] ?? 0.0,
                    bolgeData["olgunluk2"] ?? 0.0,
                    bolgeData["olgunluk3"] ?? 0.0,
                    bolgeData["olgunluk4"] ?? 0.0,
                    bolgeData["olgunluk5"] ?? 0.0,
                    bolgeData["olgunluk6"] ?? 0.0,
                    bolgeData["olgunluk7"] ?? 0.0,
                    bolgeData["olgunluk8"] ?? 0.0,
                    bolgeData["olgunluk9"] ?? 0.0,
                  ];



                  double azotOrtalama = azotOranlari.isNotEmpty
                      ? azotOranlari.reduce((a, b) => a + b) /
                          azotOranlari.length
                      : 0.0;

                  double suOrtalama = suOranlari.isNotEmpty
                      ? suOranlari.reduce((a, b) => a + b) / suOranlari.length
                      : 0.0;

                  double havaOrtalama = havaOranlari.isNotEmpty
                      ? havaOranlari.reduce((a, b) => a + b) / havaOranlari.length
                      : 0.0;

                  double olgunlukOrtalama = olgunluk.isNotEmpty
                      ? olgunluk.reduce((a, b) => a + b) / olgunluk.length
                      : 0.0;

                  int remainingDays = calculateRemainingDays(olgunlukOrtalama);

                  print(azotOrtalama);
                  print(suOrtalama);
                  print(olgunlukOrtalama);

                  List<double> saglikDurumu = [];
                  for (int i = 0; i < azotOranlari.length; i++) {
                    int azotOrani = azotOranlari[i];
                    int suOrani = suOranlari[i];
                    int havaOrani = havaOranlari[i];

                    double health = (azotOrani + suOrani + havaOrani) / 3;
                    saglikDurumu.add(health);



                  }
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tarlaAdi,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Tarla Ekim Tarihi: $ekimTarihi',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 420,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: 9,
                          itemBuilder: (BuildContext context, int index) {
                            Color bgColor = _getColorForSaglik(saglikDurumu[index]
                                .toDouble());
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('${index + 1}. Bölge'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  "Azot Oranı: %${azotOranlari[index]}"),
                                            ),
                                            ListTile(
                                              title: Text(
                                                  "Su Oranı: %${suOranlari[index]}"),
                                            ),
                                             ListTile(
                                              title: Text(
                                                  "Hava Oranı: %${havaOranlari[index]}"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                // Aktif kullanıcının e-posta adresini al
                                                final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

                                                // Notun içeriği oluştur
                                                final String baslik = tarlaAdi;
                                                final String bolumAdi = '${index + 1}. Bölge';
                                                final int azotOrani = azotOranlari[index];
                                                final int suOrani = suOranlari[index];
                                                final int havaOrani = havaOranlari[index];
                                                final String notIcerik =
                                                    'Bölge: $bolumAdi\nAzot Oranı: %$azotOrani\nSu Oranı: %$suOrani\nHava Oranı: %$havaOrani';

                                                // Firestore'a notu ekle
                                                await FirebaseFirestore.instance
                                                    .collection('Notlar')
                                                    .doc(userEmail)
                                                    .collection('notlar')
                                                    .doc('ornek')
                                                    .set({
                                                  'baslik': baslik,
                                                  'metin': notIcerik,
                                                });

                                                // Notlar sayfasına yönlendirme yap
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Notlar(
                                                      araziAdi: tarlaAdi, // Arazinin adını parametre olarak gönder
                                                    ),
                                                  ),
                                                );
                                              },

                                              child: const Text('Not Al'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Popup'ı kapat
                                              },
                                              child: const Text('Kapat'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Genel Tarla Verileri',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildProgressBar('Azot Oranı', azotOrtalama),
                              const SizedBox(height: 10),
                              _buildProgressBar('Su Oranı', suOrtalama),
                              const SizedBox(height: 10),
                              _buildProgressBar('Hava Oranı', havaOrtalama),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          const Text(
                            'Tahmini Olgunluk Düzeyi',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Image.asset(
                            'assets/bitki_asama/b5.jpg',
                            height: 300,
                          ),
                          Text(
                            "%${olgunlukOrtalama.toStringAsFixed(1)}",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hasat için kalan tahmini süre: ',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    '$remainingDays Gün',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                      child: Text('Veri yüklenirken bir hata oluştu.'));
                }
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('Veri yüklenirken bir hata oluştu.'));
          }
        },
      ),
    );
  }

  Color _getColorForSaglik(double value) {
    if (value >= 90) {
      return Colors.green[400]!; // %90 ve üzeri (en koyu yeşil tonu)
    } else if (value >= 80) {
      return Colors.green[600]!; // %80 - %89 arası
    } else if (value >= 70) {
      return Colors.green[700]!; // %70 - %79 arası
    } else if (value >= 60) {
      return Colors.green[800]!; // %60 - %69 arası
    } else if (value >= 50) {
      return Colors.lime[900]!; // %50 - %59 arası
    } else if (value >= 40) {
      return Colors.lime[800]!; // %40 - %49 arası
    } else if (value >= 30) {
      return Colors.lime[600]!; // %30 - %39 arası
    } else if (value >= 20) {
      return Colors.lightGreen[700]!; // %20 - %29 arası
    } else if (value >= 10) {
      return Colors.lightGreen[600]!; // %10 - %19 arası
    } else {
      return Colors.lightGreen[400]!; // %10'dan düşük (en açık yeşil tonu)
    }
  }

  Widget _buildProgressBar(String title, double value) {
    Color progressBarColor = Colors.red;
    if (value >= 45) {
      progressBarColor = Colors.green;
    } else if (value >= 30) {
      progressBarColor = Colors.yellow;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
        ),
      ],
    );
  }
}
