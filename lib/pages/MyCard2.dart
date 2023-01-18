import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyCard2 extends StatelessWidget {
  final String category;
  final color;
  final img;
  final double width;
  final double h;
  final double w;
  final double f;
  const MyCard2(
      {super.key,
      required this.category,
      this.color,
      this.img,
      required this.width,
      required this.h,
      required this.w,
      required this.f});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Center(
              child: Image(
                image: AssetImage(
                  img,
                ),
                height: h,
                width: w,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                category.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: f,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
