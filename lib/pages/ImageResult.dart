import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:irecycle/pages/MyCard2.dart';
import 'package:irecycle/scan_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../onBording/style.dart';
import 'Mycard.dart';

final _controller = PageController();
final _controller2 = PageController();

class ImageResult extends StatelessWidget {
  final String result;

  const ImageResult({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_circle_left_sharp,
                size: 40,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recognition ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Result',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 700,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: [
                MyCard2(
                  category: 'THIS IS A ' + result.toUpperCase(),
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/290C268D-B7D6-4B19-B104-68FBAAF2D007.png',
                  h: 250,
                  w: 700,
                  f: 50,
                ),
                MyCard2(
                  category: '4 tips to recycle ' +
                      result +
                      ':\n\n1. No bags. Like really, no bags.\n2. Small things are big problems\n3. Make sure it’s clean, empty and dry\n4. Combined materials are trash',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/B6057A36-3281-4CD6-A8EF-8DAB5EBF14AC.png',
                  h: 230,
                  w: 700,
                  f: 23,
                ),
                MyCard2(
                  category: 'START RECYCLING NOW',
                  color: Theme.of(context).primaryColorLight,
                  width: 390,
                  img: 'assets/images/8E286D7B-44C5-4688-9D7F-607339723A9B.png',
                  h: 250,
                  w: 700,
                  f: 50,
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
        ]),
      ),
    );
  }
}
