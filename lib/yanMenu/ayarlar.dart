import 'package:flutter/material.dart';

class Ayarlar extends StatefulWidget {
  @override
  _AyarlarState createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {
  bool bildirimlerAcik = true;
  bool temaKoyu = false;
  String seciliDil = 'TR';

  Map<String, Map<String, String>> dilMetinleri = {
    'TR': {
      'Ayarlar': 'Ayarlar',
      'Bildirimler': 'Bildirimler',
      'Gizlilik ve Güvenlik': 'Gizlilik ve Güvenlik',
      'Dil': 'Dil',
      'Temayı Değiştir': 'Temayı Değiştir',
      'Hakkında': 'Hakkında',
    },
    'EN': {
      'Ayarlar': 'Settings',
      'Bildirimler': 'Notifications',
      'Gizlilik ve Güvenlik': 'Privacy and Security',
      'Dil': 'Language',
      'Temayı Değiştir': 'Change Theme',
      'Hakkında': 'About',
    },
    'FR': {
      'Ayarlar': 'Paramètres',
      'Bildirimler': 'Notifications',
      'Gizlilik ve Güvenlik': 'Confidentialité et Sécurité',
      'Dil': 'Langue',
      'Temayı Değiştir': 'Changer de thème',
      'Hakkında': 'À propos',
    },
    'DEU': {
      'Ayarlar': 'Einstellungen',
      'Bildirimler': 'Notifications',
      'Gizlilik ve Güvenlik': 'Datenschutz und Sicherheit',
      'Dil': 'Sprache',
      'Temayı Değiştir': 'Thema ändern',
      'Hakkında': 'Über',
    },
    'PL': {
      'Ayarlar': 'Ustawienia',
      'Bildirimler': 'Powiadomienia',
      'Gizlilik ve Güvenlik': 'Prywatność i Ochrona',
      'Dil': 'Język',
      'Temayı Değiştir': 'Zmień Motyw',
      'Hakkında': 'Dookoła',
    },
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: temaKoyu ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              _goBack(context);
            },
          ),
          title: Text(dilMetinleri[seciliDil]!['Ayarlar']!),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(
                  dilMetinleri[seciliDil]!['Bildirimler']!,
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Switch(
                  value: bildirimlerAcik,
                  onChanged: (newValue) {
                    setState(() {
                      bildirimlerAcik = newValue;
                      // Burada bildirimlerin açık/kapalı durumuna göre yapılacak işlemleri gerçekleştirebilirsiniz.
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.security),
                title: Text(
                  dilMetinleri[seciliDil]!['Gizlilik ve Güvenlik']!,
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  // Handle tap
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        dilMetinleri[seciliDil]!['Dil']!,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    DropdownButton<String>(
                      value: seciliDil,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.grey[600]),
                      onChanged: (String? newValue) {
                        setState(() {
                          seciliDil = newValue!;
                          // Burada dilin durumuna göre yapılacak işlemleri gerçekleştirebilirsiniz.
                        });
                      },
                      items: <String>['TR', 'EN', 'FR', 'DEU','PL']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/dil/${value.toLowerCase()}.png',
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(width: 10),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                onTap: () {
                  // Handle tap
                },
              ),

              const Divider(),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: Text(
                  dilMetinleri[seciliDil]!['Temayı Değiştir']!,
                  style: TextStyle(fontSize: 18,),
                ),
                trailing: Switch(
                  value: temaKoyu,
                  onChanged: (newValue) {
                    setState(() {
                      temaKoyu = newValue;
                      // Burada temanın koyu/açık durumuna göre yapılacak işlemleri gerçekleştirebilirsiniz.
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  dilMetinleri[seciliDil]!['Hakkında']!,
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  // Handle tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  _goBack(BuildContext context) {
    Navigator.pop(context);
  }
}

void main() {
  runApp(Ayarlar());
}
