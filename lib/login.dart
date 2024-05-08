import 'package:deneme_flutter/bilesenler/basvuru.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin/admin.dart';
import 'bilesenler/metin_girdisi.dart';
import 'bilesenler/sifre_unuttum.dart';
import 'main.dart';

final TextEditingController usernameController = TextEditingController();
final TextEditingController passController = TextEditingController();

class Login extends StatelessWidget {
  Login({Key? key});

  void adminGiris(BuildContext context) {
    TextEditingController adminUsernameController = TextEditingController();
    TextEditingController adminPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Admin Girişi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Metin_girdisi(
                controller: adminUsernameController,
                hintText: 'Kullanıcı Adı',
                obscureText: false,
              ),
              SizedBox(height: 20),
              Metin_girdisi(
                controller: adminPassController,
                hintText: 'Şifre',
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (adminUsernameController.text == 'admin' &&
                    adminPassController.text == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminPanel()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hatalı kullanıcı adı veya şifre'),
                    ),
                  );
                }
              },
              child: Text('Giriş'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              InkWell(
                onLongPress: () {
                  adminGiris(context);
                },
                child: Container(
                  height: 200,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              SizedBox(height: 50),
              Text(
                "BeeByte",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 25),
              Metin_girdisi(
                controller: usernameController,
                hintText: 'Kullanıcı Adı',
                obscureText: false,
              ),
              SizedBox(height: 25),
              Metin_girdisi(
                controller: passController,
                hintText: 'Şifre',
                obscureText: true,
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SifreUnuttum()),
                        );
                      },
                      child: Text(
                        'Şifreni mi unuttun?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Buton(onTap: () {  },),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),

                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Müşteri değil misin?",
                    style: TextStyle(color: Colors.grey[700],),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Basvuru()),
                      );
                    },
                    child: Text(
                      "Hemen Başvur!",
                      style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Buton extends StatelessWidget {
  final Function()? onTap;

  const Buton({Key? key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: usernameController.text,
            password: passController.text,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
          print('Kullanıcı girişi başarılı: ${userCredential.user!.uid}');
          // Giriş başarılı olduğunda istenilen işlemler yapılabilir
        } catch (e) {
          print('Kullanıcı girişi hatası: $e');
          // Hata durumunda kullanıcıya uygun geri bildirim verilebilir
        }
      },
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(color: Colors.green),
        child: Center(
          child: Text(
            'Giriş Yap',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
