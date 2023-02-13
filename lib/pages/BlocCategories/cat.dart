import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../Mycard.dart';

class Cat extends StatelessWidget {
  late String id;
  late String name;
  late String description;
  late String image;
  late Color color;

  Cat(
      {required this.name,
      required this.id,
      required this.description,
      required this.image,
      required this.color,
      Key? key});

  void delete() {
    deleteCategoryDB(id);
  }

  Future deleteCategoryDB(String id) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection('categories').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              widthFactor: 100,
              child: Utils.cacheNetworkImageWithEvent(context, image, 500, 0),
              /*
              Image.file(
                File(image),
                height: 100,
                width: 100,
              ),
              */
            ),
            Center(
              child: Text(
                name.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Color.fromARGB(255, 139, 2, 2),
                ),
                onPressed: delete,
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
