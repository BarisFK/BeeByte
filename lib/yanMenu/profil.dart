import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final TextEditingController _phoneController = TextEditingController();
class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              _goBack(context);
            },
          ),
          title: const Text('Profil'),
          centerTitle: true,
        ),
        body: ProfileListView(),
      ),
    );
  }

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class ProfileListView extends StatefulWidget {
  @override
  _ProfileListViewState createState() => _ProfileListViewState();
}

class _ProfileListViewState extends State<ProfileListView> {
  File? _selectedImage; // Seçilen fotoğraf dosyası
  String? _imageUrl;

  bool isEditing = false;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _selectAndUploadImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path); // Seçilen fotoğrafı ayarla
      });

      // Firebase Storage'a fotoğrafı yükle
      Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/${_auth.currentUser!.uid}');
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);

      // Yükleme tamamlandıktan sonra URL'yi al ve Firestore'daki belgeyi güncelle
      uploadTask.whenComplete(() async {
        String imageUrl = await storageRef.getDownloadURL();

        // Firestore'daki kullanıcı belgesini güncelle
        await FirebaseFirestore.instance
            .collection('Kullanicilar')
            .doc(_auth.currentUser!.email)
            .update({'profileImageUrl': imageUrl});
        setState(() {
          _imageUrl = imageUrl; // Güncellenmiş imageUrl'ı sakla
        });
      });
    }
  }
  void _fetchProfileImageUrl() {
    FirebaseFirestore.instance
        .collection('Kullanicilar')
        .doc(_auth.currentUser!.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          _phoneController.text = snapshot['kullaniciTelefon'] ?? '';
          _imageUrl = snapshot['profileImageUrl']; // Firestore'dan imageUrl'ı al
        });
      }
    }).catchError((error) {
      print('Firestore veri alınamadı: $error');
    });
  }

  Future<void> _updatePhoneNumber(String newPhoneNumber) async {
    try {
      await FirebaseFirestore.instance.collection('Kullanicilar').doc(_auth.currentUser!.email).update({
        'kullaniciTelefon': newPhoneNumber,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Telefon numarası güncellendi.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Telefon numarası güncellenirken bir hata oluştu: $e'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Kullanicilar')
          .doc(_auth.currentUser!.email)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        _fetchProfileImageUrl();
        var profilData = snapshot.data!.data() as Map<String, dynamic>;
        String kullaniciSehir = profilData['kullaniciSehir'] ?? '';
        int kullaniciYas = profilData['kullaniciYas'] ?? '';
        String kullaniciAd = profilData['kullaniciAd'] ?? '';
        String kullaniciTelefon = profilData['kullaniciTelefon'] ?? '';
print(_imageUrl);
        return ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            GestureDetector(
              onTap: _selectAndUploadImage,
              child: CircleAvatar(
                radius: 90,

                backgroundImage: _imageUrl != null
                    ? NetworkImage(_imageUrl!) // Firestore'dan gelen fotoğrafı göster
                    : AssetImage('assets/profile.png') as ImageProvider<Object>, // Varsayılan profil fotoğrafı
                child: _selectedImage == null && _imageUrl == null
                    ? Icon(Icons.camera_alt, size: 48, color: Colors.grey[600]) // Kamera simgesi ekle
                    : null, // Fotoğraf geldiyse ekstra bir widget gösterme
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 5),
                  Text(
                    'Profil Bilgileri',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [

                UserInfoBox(label: 'Ad', value: kullaniciAd),
                UserInfoBox(label: 'Yaş', value: kullaniciYas.toString()),
                UserInfoBox(label: 'Şehir', value: kullaniciSehir),
                UserInfoBox(label: 'E Posta', value: _auth.currentUser!.email.toString()),

                SizedBox(height: 10),
                _buildEditableUserInfo(
                  label: 'Telefon',
                  value: kullaniciTelefon,
                  controller: phoneController,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                    if (!isEditing) {
                      _updatePhoneNumber(phoneController.text);
                      print('E-posta: ${emailController.text}');
                      print('Telefon: ${phoneController.text}');
                      emailController.clear();
                      phoneController.clear();
                    }
                  });
                },
                child: Text(
                  isEditing ? 'Onayla' : 'Telefon Numarası Güncelle',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.green : Colors.greenAccent[400],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),


          ],
        );
      },
    );
  }

  Widget _buildEditableUserInfo({
    required String label,
    required String value,
    required TextEditingController controller,
  }) {
    return isEditing
        ? TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
      ),
    )
        : UserInfoBox(label: label, value: value);
  }
}

class UserInfoBox extends StatelessWidget {
  final String label;
  final String value;

  UserInfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black12, width: 3),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
