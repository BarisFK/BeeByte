import 'package:deneme_flutter/onboard/onboard_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardEkran extends StatefulWidget {
  const OnBoardEkran({super.key});

  @override
  State<OnBoardEkran> createState() => _OnBoardEkranState();
}

class _OnBoardEkranState extends State<OnBoardEkran> {
  final controller = OnBoardItems();
  final pageController = PageController();

  bool sonSayfa= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.green[600],
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: sonSayfa? basla(): Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: (){
                  pageController.jumpToPage(controller.items.length-1);
                },
                child: Text('Geç',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),

            //Gösterge
            SmoothPageIndicator(
                controller: pageController,
                count: controller.items.length,
                onDotClicked: (index)=> pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut),
                effect: const WormEffect(
                activeDotColor: Colors.white,
                  dotHeight: 14,
                  dotWidth: 14,
            ),
            ),
            TextButton(
                onPressed: (){
                  pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                },
                child: Text('Sonraki',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: PageView.builder(
          onPageChanged: (index) => setState(() {
            sonSayfa = controller.items.length - 1 == index;
          }),
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Expanded(
                  child: Image.asset(
                    controller.items[index].img,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    controller.items[index].title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      controller.items[index].desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget basla(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.green[300],
      ),
      width: MediaQuery.of(context).size.width*9,
      height: 57,
      child: TextButton(
        onPressed: ()async{
          final pres= await SharedPreferences.getInstance();
          pres.setBool("onboard", true);
          if(!mounted)return;
          Navigator.pushReplacementNamed(context, '/giris');
        },
        child: Text("Hadi Başlayalım", style: TextStyle(color: Colors.white),
      ),
    ));

  }
}
