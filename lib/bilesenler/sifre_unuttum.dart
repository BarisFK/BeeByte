import 'package:deneme_flutter/bilesenler/metin_girdisi.dart';
import 'package:deneme_flutter/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SifreUnuttum extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
                Icons.email,
                size: 200.0, // İkon boyutu
                color: Colors.green, // İkon rengi
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,20),
              child: Text('Lütfen kayıtlı E-Posta adresini gir',style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Metin_girdisi(
              controller: emailController,
              hintText: 'E-posta',
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _resetPassword(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
              child: Text('Şifreyi Sıfırla'),
            ),

          ],
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      // Şifre sıfırlama e-postası gönderildi, kullanıcıyı bilgilendirme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Şifre sıfırlama e-postası gönderildi.'),
        ),
      );

      // Şifre sıfırlama e-postası gönderildiyse, kullanıcıyı giriş ekranına geri yönlendir
      Navigator.pushReplacementNamed(context, "login.dart"); // '/login' buradaki giriş ekranının route adıdır
    } catch (e) {
      // Hata durumunda kullanıcıyı bilgilendirme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Şifre sıfırlama başarısız oldu. Hata: $e'),
        ),
      );
    }
  }
}
