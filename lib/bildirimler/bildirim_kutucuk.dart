import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BildirimKutucuk extends StatefulWidget {
  const BildirimKutucuk({Key? key}) : super(key: key);

  @override
  State<BildirimKutucuk> createState() => _BildirimKutucukState();
}

class _BildirimKutucukState extends State<BildirimKutucuk> {
  late String? _userEmail;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
        print(_userEmail);
      });
    } else {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          setState(() {
            _userEmail = user.email;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _userEmail null ise, CircularProgressIndicator göster
    if (_userEmail == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    // Değilse, StreamBuilder'ları oluştur
    else {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Bildirimler')
            .doc('ana')
            .collection('bildirimler')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> anaSnapshot) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Bildirimler')
                .doc('kullaniciOzel')
                .collection('kullanıcılar')
                .doc(_userEmail)
                .collection('bildirimler')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                ozelSnapshot) {
              if (anaSnapshot.connectionState == ConnectionState.waiting ||
                  ozelSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<Widget> bildirimler = [];
                // Ana bildirimler
                for (DocumentSnapshot<Map<String, dynamic>> anaDocument
                in anaSnapshot.data!.docs) {
                  Map<String, dynamic> anaData = anaDocument.data()!;
                  bildirimler.add(
                    _buildBildirimKutucuk(
                      anaData['baslik'],
                      anaData['metin'],
                      anaData['timestamp'],
                      Colors.blueGrey[300]!, // Mavi arka plan
                    ),
                  );
                }
                // Özel bildirimler
                for (DocumentSnapshot<Map<String, dynamic>> ozelDocument
                in ozelSnapshot.data!.docs) {
                  Map<String, dynamic> ozelData = ozelDocument.data()!;
                  bildirimler.add(
                    _buildBildirimKutucuk(
                      ozelData['baslik'],
                      ozelData['alt'],
                      ozelData['timestamp'],
                      Colors.green[300]!, // Yeşil arka plan
                    ),
                  );
                }
                return SizedBox(
                  height: 600,
                  child: ListView(
                    children: bildirimler,
                  ),
                );
              }
            },
          );
        },
      );
    }
  }

  Widget _buildBildirimKutucuk(
      String baslik, String alt, Timestamp zaman, Color renk) {
    DateTime zamanDateTime = zaman.toDate();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: renk, // Belirlenen renk
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                baslik,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
              child: Text(
                alt,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${zamanDateTime.day}/${zamanDateTime.month}/${zamanDateTime.year}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
