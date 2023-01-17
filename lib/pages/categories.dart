import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'Mycard.dart';

class categories extends StatefulWidget {
  const categories({super.key});

  @override
  State<categories> createState() => _categoriesState();
}

class _categoriesState extends State<categories> {
  final _controller = PageController();
  final _controller2 = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recycling',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' Tips',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: [
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/B0F2B673-2CD0-476D-9475-55670A28B2E6.png',
                  h: 150,
                  w: 700,
                ),
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/B65DAAEE-5E2D-4CD4-B1FF-F054E957747C.png',
                  h: 150,
                  w: 700,
                ),
                MyCard(
                  category: '',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/C2796A0C-48A4-4089-B959-7B1E6935738C.png',
                  h: 150,
                  w: 700,
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
              controller: _controller, // PageController
              count: 3,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Theme.of(context).primaryColorDark,
              ),
              // your preferred effect
              onDotClicked: (index) {}),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Matrial',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' Categories',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _controller2,
              children: [
                MyCard(
                  category: 'Plastic',
                  color: Color.fromARGB(255, 189, 232, 152),
                  width: 150,
                  img: 'assets/images/8BABA77D-4D45-4455-B2AA-E7346F29DB8A.png',
                  h: 100,
                  w: 100,
                ),
                MyCard(
                  category: 'Can',
                  color: Color.fromARGB(255, 249, 215, 255),
                  width: 150,
                  img: 'assets/images/B1F516F5-24C3-49A0-9C73-DFB9C53B8A49.png',
                  h: 100,
                  w: 100,
                ),
                MyCard(
                  category: 'Paper',
                  color: Color.fromARGB(255, 255, 221, 176),
                  width: 150,
                  img: 'assets/images/6A85129E-9AC5-4A37-9F66-CD59E22D356A.png',
                  h: 100,
                  w: 100,
                ),
                MyCard(
                  category: 'Glass',
                  color: Color.fromARGB(255, 189, 232, 152),
                  width: 150,
                  img: 'assets/images/35293533-33CB-4941-80FE-EB4D7279E30C.png',
                  h: 100,
                  w: 100,
                ),
                MyCard(
                  category: 'Box',
                  color: Color.fromARGB(255, 176, 230, 255),
                  width: 150,
                  img: 'assets/images/11879CE4-9519-47BE-AF87-7A21DD315EED.png',
                  h: 100,
                  w: 100,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
