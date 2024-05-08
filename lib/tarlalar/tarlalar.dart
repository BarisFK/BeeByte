import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_flutter/tarlalar/tarla_detay.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Tarlalar extends StatefulWidget {
  const Tarlalar({Key? key}) : super(key: key);

  @override
  State<Tarlalar> createState() => _TarlalarState();
}

class _TarlalarState extends State<Tarlalar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarlalar'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Tarlalar')
            .where("kullaniciEmail", isEqualTo: _auth.currentUser!.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return GridView.builder(
            itemCount: documents.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final tarla = documents[index];

              return GestureDetector(
                onTap: () {
                  String tarlaId = tarla.id;
                  // Tarla belirleyici kimliği al
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TarlaDetay(tarlaId: tarlaId),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/tarla.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(10.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          tarla['tarlaAdi'],
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
