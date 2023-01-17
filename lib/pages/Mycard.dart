import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyCard extends StatelessWidget {
  final String category;
  final color;
  final img;
  final double width;
  final double h;
  final double w;
  const MyCard(
      {super.key,
      required this.category,
      this.color,
      this.img,
      required this.width,
      required this.h,
      required this.w});

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
            Center(
              child: Image(
                image: AssetImage(
                  img,
                ),
                height: h,
                width: w,
              ),
            ),
            Center(
              child: Text(
                category.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
