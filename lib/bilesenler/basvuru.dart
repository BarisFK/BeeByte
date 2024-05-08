import 'package:deneme_flutter/login.dart';
import 'package:flutter/material.dart';

class Basvuru extends StatelessWidget {
  const Basvuru({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adController = TextEditingController();
    final soyadController = TextEditingController();
    final telefonController = TextEditingController();
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Hemen Başvur!'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/onboard/O1.jpeg',
                      height: 290,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'Bilgilerini doldur , sana ulaşalım!',
                      style: TextStyle(fontSize: 20, color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: adController,
                decoration: InputDecoration(
                  labelText: 'Ad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: soyadController,
                decoration: InputDecoration(
                  labelText: 'Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: telefonController,
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  hintText: '05(--)(---)(----)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta Adresi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (adController.text.isEmpty ||
                      soyadController.text.isEmpty ||
                      telefonController.text.isEmpty ||
                      emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lütfen tüm alanları doldurun.'),
                      ),
                    );
                  } else {
                    _showAlertDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: const Text(
                  'Başvur',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Başvurunuz Alındı',style: TextStyle(fontSize: 20),),
          content: const Text('Tarafınıza mail ve telefon yoluyla bilgilendirme yapılacaktır!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
