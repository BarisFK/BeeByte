import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KullaniciGoruntule extends StatefulWidget {
  const KullaniciGoruntule({Key? key}) : super(key: key);

  @override
  State<KullaniciGoruntule> createState() => _KullaniciGoruntuleState();
}

class _KullaniciGoruntuleState extends State<KullaniciGoruntule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Listesi'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Kullanicilar').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['kullaniciAd']),
                subtitle: Text(data['kullaniciEmail']),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KullaniciDuzenle(
                          kullaniciAd: data['kullaniciAd'],
                          kullaniciEmail: data['kullaniciEmail'],
                          kullaniciSehir: data['kullaniciSehir'],
                          kullaniciTelefon: data['kullaniciTelefon'],
                          kullaniciYas: data['kullaniciYas'],
                        ),
                      ),
                    );
                  },
                  child: Text('Düzenle', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KullaniciEkle()), // Yeni ekran için route oluştur
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class KullaniciEkle extends StatelessWidget {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sehirController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _yasController = TextEditingController();

  void _kullaniciKaydet(BuildContext context) {
    String kullaniciAd = _adController.text;
    String kullaniciEmail = _emailController.text;
    String kullaniciSehir = _sehirController.text;
    String kullaniciTelefon = _telefonController.text;
    int kullaniciYas = int.tryParse(_yasController.text) ?? 0; // Yaş bilgisini int'e çevirir, hata durumunda 0 döndürür

    FirebaseFirestore.instance.collection('Kullanicilar').doc(kullaniciEmail).set({
      'kullaniciAd': kullaniciAd,
      'kullaniciEmail': kullaniciEmail,
      'kullaniciSehir': kullaniciSehir,
      'kullaniciTelefon': kullaniciTelefon,
      'kullaniciYas': kullaniciYas,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı başarıyla eklendi')),
      );
      Navigator.pop(context); // Ekranı kapat
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı eklenirken hata oluştu: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Ekle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _adController,
              decoration: InputDecoration(labelText: 'Ad'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _sehirController,
              decoration: InputDecoration(labelText: 'Şehir'),
            ),
            TextFormField(
              controller: _telefonController,
              decoration: InputDecoration(labelText: 'Telefon'),
            ),
            TextFormField(
              controller: _yasController,
              decoration: InputDecoration(labelText: 'Yaş'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _kullaniciKaydet(context), // Kaydet butonuna basıldığında kullanıcıyı ekler
              child: Text('Kaydet', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KullaniciDuzenle extends StatefulWidget {
  final String kullaniciAd;
  final String kullaniciEmail;
  final String kullaniciSehir;
  final String kullaniciTelefon;
  final int kullaniciYas;

  const KullaniciDuzenle({
    Key? key,
    required this.kullaniciAd,
    required this.kullaniciEmail,
    required this.kullaniciSehir,
    required this.kullaniciTelefon,
    required this.kullaniciYas,
  }) : super(key: key);

  @override
  _KullaniciDuzenleState createState() => _KullaniciDuzenleState();
}

class _KullaniciDuzenleState extends State<KullaniciDuzenle> {
  late TextEditingController _adController;
  late TextEditingController _emailController;
  late TextEditingController _sehirController;
  late TextEditingController _telefonController;
  late TextEditingController _yasController;

  @override
  void initState() {
    super.initState();
    _adController = TextEditingController(text: widget.kullaniciAd);
    _emailController = TextEditingController(text: widget.kullaniciEmail);
    _sehirController = TextEditingController(text: widget.kullaniciSehir);
    _telefonController = TextEditingController(text: widget.kullaniciTelefon);
    _yasController = TextEditingController(text: widget.kullaniciYas.toString());
  }

  @override
  void dispose() {
    _adController.dispose();
    _emailController.dispose();
    _sehirController.dispose();
    _telefonController.dispose();
    _yasController.dispose();
    super.dispose();
  }

  void _kullaniciSil(BuildContext context) {
    FirebaseFirestore.instance.collection('Kullanicilar').doc(widget.kullaniciEmail).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı başarıyla silindi')),
      );
      Navigator.pop(context); // Düzenleme ekranını kapat
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme işlemi başarısız: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Düzenle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _adController,
              decoration: InputDecoration(labelText: 'Ad'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _sehirController,
              decoration: InputDecoration(labelText: 'Şehir'),
            ),
            TextFormField(
              controller: _telefonController,
              decoration: InputDecoration(labelText: 'Telefon'),
            ),
            TextFormField(
              controller: _yasController,
              decoration: InputDecoration(labelText: 'Yaş'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Kullanicilar').where('kullaniciEmail', isEqualTo: widget.kullaniciEmail).get().then((querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                        doc.reference.update({
                          'kullaniciAd': _adController.text,
                          'kullaniciEmail': _emailController.text,
                          'kullaniciSehir': _sehirController.text,
                          'kullaniciTelefon': _telefonController.text,
                          'kullaniciYas': int.parse(_yasController.text),
                        }).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Kullanıcı güncellendi')),
                          );
                          Navigator.pop(context); // Düzenleme ekranını kapat
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Güncelleme başarısız: $error')),
                          );
                        });
                      });
                    });
                  },
                  child: Text('Kaydet', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => _kullaniciSil(context), // Sil butonuna basıldığında kullanıcıyı siler
                  child: Text('Kullanıcıyı Sil', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

