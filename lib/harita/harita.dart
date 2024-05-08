
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_flutter/tarlalar/tarlalar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../tarlalar/tarla_detay.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Harita extends StatefulWidget {
  const Harita({Key? key}) : super(key: key);

  @override
  State<Harita> createState() => _HaritaState();
}

class _HaritaState extends State<Harita> {
  late GoogleMapController _controller;
  String? _selectedTarla;
  late LatLng _defaultCameraPosition;
  Map<String, LatLng> _tarlaKonumlari = {
    'Tarla - 1': LatLng(37.42796133580664, -122.085749655962),
    'Tarla - 2': LatLng(37.427, -122.085),
  };

  List<String> tarlalar = ['Tarla - 1', 'Tarla - 2'];

  @override
  void initState() {
    super.initState();
    _defaultCameraPosition =
    _tarlaKonumlari['Tarla - 1']!; // Varsayılan kamera konumu
  }

  void _onTarlaSelected(String tarlaName) {
    final selectedTarlaKonumu = _tarlaKonumlari[tarlaName];
    if (selectedTarlaKonumu != null) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: selectedTarlaKonumu,
            zoom: 18.5, // Zoom seviyesini istediğiniz değere ayarlayın
          ),
        ),
      ).then((_) {
        setState(() {
          _defaultCameraPosition = selectedTarlaKonumu;
        });
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Harita'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('Tarlalar')
                .where("kullaniciEmail", isEqualTo: _auth.currentUser!.email)
                .snapshots(),
            // StreamBuilder içindeki builder fonksiyonu
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Veri alınamıyor...'));
              }

              // Verileri documents listesine ata
              final List<DocumentSnapshot> documents = snapshot.data!.docs;

              // _tarlaKonumlari haritasını güncelle
              Map<String, LatLng> updatedTarlaKonumlari = {};

              documents.forEach((doc) {
                String tarlaAdi = doc['tarlaAdi'];
                GeoPoint tarlaKonum = doc['tarlaKonum'];

                // GeoPoint'ten LatLng'e dönüşüm
                LatLng latLng = LatLng(
                    tarlaKonum.latitude, tarlaKonum.longitude);

                // Harita güncellemesi için tarla adı ve konumu ekle
                updatedTarlaKonumlari[tarlaAdi] = latLng;
              });

              // _tarlaKonumlari haritasını güncelle
              _tarlaKonumlari = updatedTarlaKonumlari;

              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _defaultCameraPosition,
                      zoom: 17.5,
                    ),
                    mapType: MapType.satellite,
                    markers: _tarlaKonumlari.keys.map((tarlaAdi) {
                      LatLng tarlaKonumu = _tarlaKonumlari[tarlaAdi]!;
                      return Marker(
                        markerId: MarkerId(tarlaAdi),
                        position: tarlaKonumu,
                        infoWindow: InfoWindow(title: tarlaAdi),
                        onTap: () {
                         
                          _navigateToTarlaDetay(tarlaAdi);
                        },
                      );
                    }).toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  ),
                  Positioned(
                    bottom: 50,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTarla,
                          hint: const Text("Tarlaları İncele"),
                          items: documents.map((DocumentSnapshot doc) {
                            String tarlaAdi = doc['tarlaAdi'];
                            return DropdownMenuItem<String>(
                              value: tarlaAdi,
                              child: Text(tarlaAdi),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTarla = newValue;
                            });
                            if (newValue != null) {
                              _onTarlaSelected(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

        )
    );
  }

  void _navigateToTarlaDetay(String tarlaAdi) async {
    // Tıklanan tarla adıyla ilişkili tarla konumunu al
    LatLng? tarlaKonumu = _tarlaKonumlari[tarlaAdi];

    if (tarlaKonumu != null) {
      // Tarla adını kullanarak Firestore'dan ilgili belgeyi bul
      QuerySnapshot querySnapshot = await _firestore
          .collection('Tarlalar')
          .where('tarlaAdi', isEqualTo: tarlaAdi)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // İlk belgeyi al (tekil bir sonuç olduğu için)
        DocumentSnapshot tarlaDoc = querySnapshot.docs.first;

        // Tarla belgesinin ID'sini al
        String tarlaId = tarlaDoc.id;

        // TarlaDetay sayfasına tıklanan tarlanın ID'sini ileterek geçiş yap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TarlaDetay(tarlaId: tarlaId),
          ),
        );
      } else {
        print('Tarla bulunamadı: $tarlaAdi');
      }
    } else {
      print('Tarla konumu bulunamadı: $tarlaAdi');
    }
  }



}