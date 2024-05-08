import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TarlaGoruntule extends StatefulWidget {
  const TarlaGoruntule({Key? key}) : super(key: key);

  @override
  _TarlaGoruntuleState createState() => _TarlaGoruntuleState();
}

class _TarlaGoruntuleState extends State<TarlaGoruntule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarla Listesi'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tarlalar').snapshots(),
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
          // Kullanıcı e-postalarını ve onlara ait tarla isimlerini gruplamak için bir harita oluştur
          Map<String, List<String>> tarlaGruplari = {};

          // Her tarla belgesini döngüye al
          snapshot.data!.docs.forEach((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String kullaniciEmail = data['kullaniciEmail'];
            String tarlaAdi = data['tarlaAdi'];

            // Kullanıcı e-postası var mı kontrol et, eğer yoksa yeni bir liste oluştur
            if (!tarlaGruplari.containsKey(kullaniciEmail)) {
              tarlaGruplari[kullaniciEmail] = [];
            }

            // Kullanıcı e-postasına ait tarla ismini listeye ekle
            tarlaGruplari[kullaniciEmail]!.add(tarlaAdi);
          });

          // Kullanıcı e-postalarını ve onlara ait tarla isimlerini ExpansionTile içinde liste oluşturarak dönüştür
          List<Widget> kullaniciListesi = [];
          tarlaGruplari.forEach((kullaniciEmail, tarlaIsimleri) {
            kullaniciListesi.add(
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.grey[300]),
                padding: EdgeInsets.symmetric(vertical: 15), // Yüksekliği artırmak için padding ekle
                child: ExpansionTile(
                  title: Text(
                    kullaniciEmail,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: tarlaIsimleri.map((tarlaAdi) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Tarla bölümü arka planı gri
                        borderRadius: BorderRadius.circular(10), // Radius ekle
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(tarlaAdi),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Düzenle butonuna basıldığında ilgili tarla için düzenleme sayfasına yönlendir
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TarlaDuzenle(
                                  kullaniciEmail: kullaniciEmail,
                                  tarlaAdi: tarlaAdi,
                                  ekimTarihi: Timestamp.fromDate(DateTime.now()), // Ekim tarihi için örnek bir değer verdik
                                  tarlaKonum: GeoPoint(0, 0), // Tarla konumu için örnek bir değer verdik
                                ),
                              ),
                            );
                          },
                          child: Text('Düzenle'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green, // Yazı rengi beyaz
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          });

          // Kullanıcı listesini ListView'e dönüştür
          return ListView(
            children: kullaniciListesi,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tarla ekleme bottom sheet'ini aç
          showModalBottomSheet(
            context: context,
            builder: (context) => TarlaEkle(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class TarlaEkle extends StatefulWidget {
  @override
  _TarlaEkleState createState() => _TarlaEkleState();
}

class _TarlaEkleState extends State<TarlaEkle> {
  late TextEditingController _tarlaAdiController;
  late TextEditingController _ekimTarihiController;
  late TextEditingController _kullaniciEmailController;
  late TextEditingController _tarlaKonumController;
  late TextEditingController _tarlaBuyuklukController; // Yeni eklendi
  late TextEditingController _tarlaUrunController; // Yeni eklendi

  @override
  void initState() {
    super.initState();
    _tarlaAdiController = TextEditingController();
    _ekimTarihiController = TextEditingController();
    _kullaniciEmailController = TextEditingController();
    _tarlaKonumController = TextEditingController();
    _tarlaBuyuklukController = TextEditingController(); // Yeni eklendi
    _tarlaUrunController = TextEditingController(); // Yeni eklendi
  }

  @override
  void dispose() {
    _tarlaAdiController.dispose();
    _ekimTarihiController.dispose();
    _kullaniciEmailController.dispose();
    _tarlaKonumController.dispose();
    _tarlaBuyuklukController.dispose(); // Yeni eklendi
    _tarlaUrunController.dispose(); // Yeni eklendi
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Tarla Ekle',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _tarlaAdiController,
              decoration: InputDecoration(labelText: 'Tarla Adı'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _ekimTarihiController,
              decoration: InputDecoration(labelText: 'Ekim Tarihi'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _kullaniciEmailController,
              decoration: InputDecoration(labelText: 'Kullanıcı Email'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _tarlaKonumController,
              decoration: InputDecoration(labelText: 'Tarla Konumu'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _tarlaBuyuklukController,
              decoration: InputDecoration(labelText: 'Tarla Büyüklük'), // Yeni eklendi
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _tarlaUrunController,
              decoration: InputDecoration(labelText: 'Tarla Ürün'), // Yeni eklendi
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Form verilerini al
                String tarlaAdi = _tarlaAdiController.text;
                String ekimTarihi = _ekimTarihiController.text;
                String kullaniciEmail = _kullaniciEmailController.text;
                String tarlaKonum = _tarlaKonumController.text;
                String tarlaBuyukluk = _tarlaBuyuklukController.text; // Yeni eklendi
                String tarlaUrun = _tarlaUrunController.text; // Yeni eklendi
        
                // Belge adını tarla adıyla aynı yap (küçük harfler ve boşluk olmadan)
                String belgeAdi = tarlaAdi.toLowerCase().replaceAll(' ', '');
        
                // Firestore'a belgeyi ekle
                FirebaseFirestore.instance.collection('Tarlalar').doc(belgeAdi).set({
                  'tarlaAdi': tarlaAdi,
                  'ekimTarihi': ekimTarihi,
                  'kullaniciEmail': kullaniciEmail,
                  'tarlaKonum': tarlaKonum,
                  'tarlaBuyukluk': tarlaBuyukluk, // Yeni eklendi
                  'tarlaUrun': tarlaUrun, // Yeni eklendi
                }).then((value) {
                  // Ekleme başarılı olduysa bilgi ver
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tarla eklendi')),
                  );
                  // Formu temizle
                  _tarlaAdiController.clear();
                  _ekimTarihiController.clear();
                  _kullaniciEmailController.clear();
                  _tarlaKonumController.clear();
                  _tarlaBuyuklukController.clear(); // Yeni eklendi
                  _tarlaUrunController.clear(); // Yeni eklendi
                }).catchError((error) {
                  // Ekleme başarısız olduysa hata mesajı ver
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tarla eklenirken bir hata oluştu: $error')),
                  );
                });
              },
              child: Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}


class TarlaDuzenle extends StatefulWidget {
  final String kullaniciEmail;
  final String tarlaAdi;
  final Timestamp ekimTarihi;
  final GeoPoint tarlaKonum;

  const TarlaDuzenle({
    Key? key,
    required this.kullaniciEmail,
    required this.tarlaAdi,
    required this.ekimTarihi,
    required this.tarlaKonum,
  }) : super(key: key);

  @override
  _TarlaDuzenleState createState() => _TarlaDuzenleState();
}

class _TarlaDuzenleState extends State<TarlaDuzenle> {
  late TextEditingController _tarlaAdiController;
  late TextEditingController _ekimTarihiController;
  late TextEditingController _tarlaBuyuklukController;
  late TextEditingController _tarlaUrunController;

  @override
  void initState() {
    super.initState();
    _tarlaAdiController = TextEditingController(text: widget.tarlaAdi);
    _ekimTarihiController = TextEditingController(text: widget.ekimTarihi.toDate().toString());
    _tarlaBuyuklukController = TextEditingController();
    _tarlaUrunController = TextEditingController();

    // Firestore'dan ilgili tarla belgesini çek
    FirebaseFirestore.instance.collection('Tarlalar')
        .where('tarlaAdi', isEqualTo: widget.tarlaAdi) // İlgili tarla adına bağlı olarak belgeyi bul
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        // Firestore'dan gelen verileri ilgili alanlara ata
        setState(() {
          _tarlaBuyuklukController.text = data['tarlaBuyukluk'] != null ? data['tarlaBuyukluk'].toString() : '';
          _tarlaUrunController.text = data['tarlaUrun'] ?? '';
        });
      }
    })
        .catchError((error) {
      print('Hata oluştu: $error');
    });
  }



  @override
  void dispose() {
    _tarlaAdiController.dispose();
    _ekimTarihiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarla Düzenle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _tarlaAdiController,
              decoration: InputDecoration(labelText: 'Tarla Adı'),
            ),
            TextFormField(
              controller: _ekimTarihiController,
              decoration: InputDecoration(labelText: 'Ekim Tarihi'),
              // DateTimePicker gibi bir paket kullanarak tarih seçme işlemi yapılabilir
            ),
            TextFormField(
              controller: _tarlaBuyuklukController,
              decoration: InputDecoration(labelText: 'Tarla Büyüklük'),
            ),
            TextFormField(
              controller: _tarlaUrunController,
              decoration: InputDecoration(labelText: 'Tarla Ürün'),
            ),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Firebase'deki tarla bilgilerini güncelleme işlemi
                FirebaseFirestore.instance.collection('Tarlalar').doc(widget.kullaniciEmail).update({
                  'tarlaAdi': _tarlaAdiController.text,
                  // Ekim tarihi için güncelleme işlemi yapılmadı, gerekirse eklenmeli
                }).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tarla güncellendi')),
                  );
                  Navigator.pop(context); // Düzenleme ekranını kapat
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Güncelleme başarısız: $error')),
                  );
                });
              },
              child: Text('Kaydet', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Firebase'den tarlayı silme işlemi
                FirebaseFirestore.instance.collection('Tarlalar')
                    .where('tarlaAdi', isEqualTo: widget.tarlaAdi)
                    .get()
                    .then((querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    doc.reference.delete().then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tarla silindi')),
                      );
                      Navigator.pop(context); // Düzenleme ekranını kapat
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Silme başarısız: $error')),
                      );
                    });
                  });
                });
              },
              child: Text('Sil', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),



          ],
        ),
      ),
    );
  }
}
