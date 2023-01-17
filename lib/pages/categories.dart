import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Mycard.dart';

class categories extends StatefulWidget {
  const categories({super.key});

  @override
  State<categories> createState() => _categoriesState();
}

class _categoriesState extends State<categories> {
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
              children: [
                MyCard(
                  category: 'Plastic',
                  color: Color.fromARGB(255, 189, 232, 152),
                  img: 'assets/images/8BABA77D-4D45-4455-B2AA-E7346F29DB8A.png',
                ),
                MyCard(
                  category: 'Can',
                  color: Color.fromARGB(255, 249, 215, 255),
                  img: 'assets/images/B1F516F5-24C3-49A0-9C73-DFB9C53B8A49.png',
                ),
                MyCard(
                  category: 'Paper',
                  color: Color.fromARGB(255, 255, 221, 176),
                  img: 'assets/images/6A85129E-9AC5-4A37-9F66-CD59E22D356A.png',
                ),
                MyCard(
                  category: 'Glass',
                  color: Color.fromARGB(255, 189, 232, 152),
                  img: 'assets/images/35293533-33CB-4941-80FE-EB4D7279E30C.png',
                ),
                MyCard(
                  category: 'Box',
                  color: Color.fromARGB(255, 176, 230, 255),
                  img: 'assets/images/11879CE4-9519-47BE-AF87-7A21DD315EED.png',
                ),
              ],
            ),
          ),
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
        ]),
      ),
    );
  }
}
