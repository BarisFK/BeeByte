import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BildirimGonder extends StatefulWidget {
  const BildirimGonder({Key? key}) : super(key: key);

  @override
  State<BildirimGonder> createState() => _BildirimGonderState();
}

class _BildirimGonderState extends State<BildirimGonder> {
  final TextEditingController _baslikController = TextEditingController();
  final TextEditingController _metinController = TextEditingController();
  String? _secilenKullanici;

  @override
  void dispose() {
    _baslikController.dispose();
    _metinController.dispose();
    super.dispose();
  }

  void _showGenelBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Genel Bildirim Gönder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _baslikController,
                decoration: InputDecoration(
                  hintText: 'Başlık',
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _metinController,
                decoration: InputDecoration(
                  hintText: 'Metin',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _bildirimGonder();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: Text('Gönder'),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      // Bottom sheet kapatıldığında TextField'ları sıfırla
      _baslikController.clear();
      _metinController.clear();
    });
  }

  void _showOzelBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FutureBuilder(
              future: _getKullanicilar(),
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('Kullanıcılar bulunamadı'));
                }
                return Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Özel Bildirim Gönder',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ExpansionTile(
                        title: Text(_secilenKullanici ?? 'Kullanıcı Seçin'),
                        children: snapshot.data!.map<Widget>((String value) {
                          return ListTile(
                            title: Text(value),
                            onTap: () {
                              setState(() {
                                _secilenKullanici = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _baslikController,
                        decoration: InputDecoration(
                          hintText: 'Başlık',
                        ),
                        enableInteractiveSelection: true, // Etkileşimli seçimi etkinleştir
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: _metinController,
                        decoration: InputDecoration(
                          hintText: 'Metin',
                        ),
                        enableInteractiveSelection: true, // Etkileşimli seçimi etkinleştir
                      ),

                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          _bildirimGonder();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Gönder'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).then((value) {
      // Bottom sheet kapatıldığında TextField'ları sıfırla
      _baslikController.clear();
      _metinController.clear();
      _secilenKullanici = null;
    });
  }


  Future<List<String>> _getKullanicilar() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Kullanicilar').get();
    List<String> kullaniciListesi = [];
    querySnapshot.docs.forEach((document) {
      kullaniciListesi.add(document['kullaniciAd']);
    });
    return kullaniciListesi;
  }

  void _bildirimGonder() {
    String baslik = _baslikController.text;
    String metin = _metinController.text;
    String secilenKullanici = _secilenKullanici ?? 'Seçilmedi'; // Default olarak seçilmediyi ekleyebilirsiniz
    Timestamp timestamp = Timestamp.now();

    FirebaseFirestore.instance.collection('Bildirimler').doc('ana').collection('bildirimler').doc(baslik).set({
      'baslik': baslik,
      'metin': metin,
      'kullanici': secilenKullanici,
      'timestamp': timestamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Mevcut Bildirimler',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Bildirimler').doc('ana').collection('bildirimler').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['baslik']),
                      subtitle: Text(data['metin']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          // Silme işlemi
                          _silBildirim(data['baslik']);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showGenelBottomSheet(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: Text('Genel Bildirim Gönder'),
          ),
          SizedBox(height: 5.0),
          ElevatedButton(
            onPressed: () {
              _showOzelBottomSheet(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: Text('Özel Bildirim Gönder'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _silBildirim(String baslik) {
    FirebaseFirestore.instance.collection('Bildirimler').doc('ana').collection('bildirimler').doc(baslik).delete();
  }
}
