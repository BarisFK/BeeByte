import 'package:flutter/material.dart';

class HaberDetay extends StatefulWidget {
  final int index;
  const HaberDetay({Key? key, required this.index}) : super(key: key);

  @override
  _HaberDetayState createState() => _HaberDetayState();
}

class _HaberDetayState extends State<HaberDetay> {
  late int index1;
  late String baslik;
  late String metin;

  @override
  void initState() {
    super.initState();
    index1 = widget.index;


    if (index1 == 0) {
      baslik = 'Tarımsal Destekler Çiftçinin Yüzünü Güldürdü';
      metin = 'Hükümetin tarım sektörüne sağladığı yeni destek paketleri, çiftçiler arasında olumlu karşılandı. Özellikle genç çiftçilere yönelik hibe ve eğitim programları, sektördeki yenilikçi girişimlerin önünü açıyor. Çiftçiler, bu desteklerle daha kaliteli ürün yetiştirip, pazarlama olanaklarını genişletebileceklerini belirtiyor.';
    } else if (index1 == 1) {
      baslik = 'Yerli Traktörler Uluslararası Ödüle Layık Görüldü';
      metin = 'Türkiye’nin yerli traktör üreticilerinden biri olan Massey Ferguson’un MF 9S Serisi, tarım sektöründe teknoloji ve tasarımın mükemmel uyumunu sergileyerek uluslararası "Red Dot Tasarım Ödülü"nü kazandı1. Yenilikçi özellikleri ve çiftçilerin ihtiyaçlarına yönelik geliştirilen ergonomik tasarımı ile dikkat çeken MF 9S Serisi, tarım makinaları kategorisinde bu prestijli ödüle layık görülerek Türkiye’nin mühendislik ve tasarım kabiliyetini dünya çapında kanıtlamış oldu.';
    } else if (index1 == 2) {
      baslik = 'Yenilikçi Tarım Teknolojileriyle Verimlilik Artıyor';
      metin = 'Türkiye’nin önde gelen tarım teknolojisi şirketleri, su tasarrufu sağlayan damla sulama sistemleri ve verimliliği artıran otomatik tohum ekim makineleri gibi yenilikçi çözümler sunuyor. Bu teknolojiler sayesinde çiftçiler, kuraklık ve artan girdi maliyetleri gibi zorluklara karşı daha dirençli hale geliyor.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          children: [
            Image.asset(
              'assets/haber/h$index1.jpeg',
              width: 400,
              height: 400,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  baslik,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                metin,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
