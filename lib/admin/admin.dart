import 'package:deneme_flutter/admin/bildirim.dart';
import 'package:deneme_flutter/admin/kullanici.dart';
import 'package:deneme_flutter/admin/tarla.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Admin Paneli'),
        ),
        body: ListView(
          children: [
            AdminItem(
              title: 'Kullanıcıları Görüntüle',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KullaniciGoruntule()),
                );
              },
              color: Colors.green,
            ),
            AdminItem(
              title: 'Tarlaları Görüntüle',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TarlaGoruntule()),
                );
              },
              color: Colors.grey,
            ),
            AdminItem(
              title: 'Bildirimler',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BildirimGonder()),
                );
              },
              color: Colors.green,
            ),
            // Diğer admin işlemleri buraya eklenebilir
          ],
        ),
      ),
    );
  }
}

class AdminItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;

  const AdminItem({Key? key, required this.title, required this.onPressed, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        trailing: ElevatedButton(
          onPressed: onPressed,
          child: Text('Git'),
        ),
      ),
    );
  }
}
