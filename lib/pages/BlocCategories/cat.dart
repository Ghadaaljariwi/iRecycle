import 'dart:io';

import 'package:flutter/material.dart';

import '../Mycard.dart';

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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: 150,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 189, 232, 152),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.file(
                File(image),
                height: 100,
                width: 100,
              ),
            ),
            Center(
              child: Text(
                name.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
    /*
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
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
    );
    */
  }
}
