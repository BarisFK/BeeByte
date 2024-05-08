import 'package:deneme_flutter/admin/tarlaBolge.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_flutter/login.dart';
import 'package:deneme_flutter/yanMenu/profil.dart';
import 'package:deneme_flutter/yanMenu/notlar.dart';
import 'package:deneme_flutter/yanMenu/canli_takip.dart';
import 'package:deneme_flutter/tarlalar/tarlalar.dart';
import 'package:deneme_flutter/yanMenu/takvim.dart';
import 'package:deneme_flutter/yanMenu/ayarlar.dart';

class YanMenu extends StatefulWidget {
  const YanMenu({Key? key}) : super(key: key);

  @override
  _YanMenuState createState() => _YanMenuState();
}

class _YanMenuState extends State<YanMenu> {
  late String _profileImageUrl = 'assets/profile.png'; // Varsayılan profil fotoğrafı
  late String _userName = 'Ahmet'; // Varsayılan kullanıcı adı

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Kullanıcı profilini Firestore'dan getir
  }

  void _fetchUserProfile() {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    FirebaseFirestore.instance
        .collection('Kullanicilar')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          _profileImageUrl = snapshot['profileImageUrl'] ?? '';
          _userName = snapshot['kullaniciAd'] ?? '';
          Image.network(_profileImageUrl);

        });
      }
    }).catchError((error) {
      print('Firestore veri alınamadı: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 260,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profil()),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: _profileImageUrl.isNotEmpty
                            ? Image.network(_profileImageUrl).image
                            : AssetImage('assets/profile.png'),
                        radius: 48,
                      ),

                    ),
                  ),
                  const Text(
                    'Hoş Geldin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    _userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.event_note),
                  title: const Text('Notlar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Notlar(araziAdi: '')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.video_call_outlined),
                  title: const Text('Canlı Takip'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CanliTakip()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_chart),
                  title: const Text('Tarlalar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Tarlalar()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profil'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profil()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('Takvim'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Takvim()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Ayarlar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Ayarlar()),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((_) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Login()),
                        (route) => false,
                  );
                }).catchError((error) {
                  print('Çıkış yaparken hata oluştu: $error');
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button background color to red
              ),
              child: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
