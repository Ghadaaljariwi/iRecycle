import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/pages/MyCard2.dart';
import 'package:irecycle/scan_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../onBording/style.dart';
import 'Mycard.dart';

final _controller = PageController();
final _controller2 = PageController();
String advice = "";
String result2 = "";
String image = "";

class ImageResult extends StatelessWidget {
  final String result;

  const ImageResult({
    super.key,
    required this.result,
  });

  void resultA() {
    String result2 = result;
    if (result[0] == "1") {
      image = 'assets/images/B5B010A4-9372-49F9-967F-9FC665BCC8E3.png';
      result2 = "PET or PETE";
      advice =
          "PET or PETE (polyethylene terephthalate) is the most common plastic for single-use bottled beverages because it's inexpensive, lightweight and easy to recycle. Found in: Soft drinks, water, ketchup and beer bottles.";
    } else if (result[0] == "2") {
      image = 'assets/images/hdpe.png';
      result2 = "HDPE";
      advice =
          'HDPE (high density polyethylene) is a versatile plastic with many uses, especially when it comes to packaging. Found in: Milk jugs, juice bottles, bleach, detergent and other household cleaner bottles.';
    } else if (result[0] == "3") {
      image = 'assets/images/pvc.png';
      result2 = "PVC";
      advice =
          "PVC (polyvinyl chloride) and V (vinyl) is tough and weathers well, so it's commonly used for things like piping and siding. Found in: Blister packaging, wire jacketing, siding, windows, piping.";
    } else if (result[0] == "4") {
      image = 'assets/images/ldpe.png';
      result2 = "LDPE";
      advice =
          "LDPE (low density polyethylene) is a flexible plastic with many applications. Found in: Squeezable bottles, bread, frozen food, dry cleaning, and shopping bags.";
    } else if (result[0] == "5") {
      image = 'assets/images/pp.png';
      result2 = "PP";
      advice =
          "PP (polypropylene) has a high melting point, so it's often chosen for containers that will hold hot liquid. Found in: Some yogurt containers, syrup and medicine bottles, caps, straws.";
    } else if (result[0] == "6") {
      image = 'assets/images/ps.png';
      result2 = "PS";
      advice =
          "PS (polystyrene) can be made into rigid or foam products — in the latter case, it is popularly known as the trademark Styrofoam. Found in: Disposable plates and cups, meat trays, egg cartons, carry-out containers.";
    } else if (result[0] == "7") {
      image = 'assets/images/plastic.png';
      result2 = "OTHER";
      advice =
          "A wide variety of plastic resins that don't fit into the previous categories are lumped into this one. Found in: Three- and five-gallon water bottles, bullet-proof materials, sunglasses, DVDs, iPod and computer cases.";
    } else {
      image = 'assets/images/error.png';
      result2 = "(we could not recognize it)";
      advice = "";
    }
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    resultA();
    print(advice);
    print(result);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    category: 'THIS IS A ' + result2,
                    color: Theme.of(context).primaryColorLight,
                    width: 390,
                    img: image,
                    h: 250,
                    w: 700,
                    f: 20,
                  ),
                  MyCard2(
                    category: ' tips to recycle ' + result2 + ":\n\n" + advice,
                    color: Theme.of(context).primaryColorLight,
                    width: 390,
                    img: image,
                    h: 230,
                    w: 700,
                    f: 20,
                  ),
                  MyCard2(
                    category: 'START RECYCLING NOW',
                    color: Theme.of(context).primaryColorLight,
                    width: 390,
                    img:
                        'assets/images/8E286D7B-44C5-4688-9D7F-607339723A9B.png',
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
      ),
    );
  }
}
