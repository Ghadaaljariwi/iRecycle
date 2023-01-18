import 'dart:io';

import 'package:flutter/material.dart';

class Cat extends StatelessWidget {
  late String id;
  late String name;
  late String description;
  late String image;

  Cat(
      {required this.name,
      //this.id,
      required this.description,
      required this.image,
      Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Text(name),
            SizedBox(
              height: 20,
            ),
            Text(description),
            SizedBox(
              height: 20,
            ),
            Image.file(
              File(image),
              width: 160,
              height: 160,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
