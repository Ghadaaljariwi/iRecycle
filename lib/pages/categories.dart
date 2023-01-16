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
                  category: 'A',
                  color: Theme.of(context).primaryColor,
                  // img: 'assets/images/recycling (2).png',
                ),
                MyCard(
                  category: 'B',
                  color: Colors.lightGreen,
                  //   img: 'assets/images/recycling (2).png',
                ),
                MyCard(
                  category: 'C',
                  color: Color.fromARGB(255, 217, 255, 176),
                  //   img: 'assets/images/recycling (2).png',
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
