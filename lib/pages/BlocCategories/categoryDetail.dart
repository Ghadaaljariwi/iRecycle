import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:irecycle/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'package:irecycle/pages/BlocCategories/addCategory.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';

import '../../common/utils.dart';
import '../../controllers/FBStorage.dart';
import 'bloc/category_bloc.dart';
import 'cat.dart';
import 'category.dart';

class CategoryDetail extends StatefulWidget {
  final DocumentSnapshot cat;
  late bool admin;

  CategoryDetail({
    Key? key,
    required this.cat,
    required this.admin,
  }) : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  late DocumentSnapshot _cat;
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchCat(widget.catId);
  // }

  // void _fetchCat(String id) async {
  //   final cat =
  //       await FirebaseFirestore.instance.collection('categories').doc(id).get();
  //   setState(() {
  //     _cat = cat;
  //   });
  // }
  int count = 0;
  void delete() {
    showDialog(
        context: context,
        builder: (context) {
          // set up the buttons
          Widget cancelButton = TextButton(
            child: Text(
              "No",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            onPressed: () => Navigator.popUntil(
              context,
              (route) {
                return count++ == 2;
              },
            ),
          );
          Widget continueButton = TextButton(
            child: Text(
              "Yes",
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            onPressed: () {
              deleteCategoryDB(widget.cat['id']);
            },
          );

          return AlertDialog(
            title: Text(
              'Delete Category',
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            content: Text(
              'Are you sure you want to delete this category ?',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              cancelButton,
              continueButton,
            ],
          );
        });
  }

  Future deleteCategoryDB(String id) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection('categories').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Details'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.cat['image'] != null &&
                widget.cat['image'].startsWith('http'))
              Image.network(
                widget.cat['image'],
                height: 450,
                width: 450,
              ),
            SizedBox(height: 5),
            Text(
              widget.cat['name'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              child: Text(
                widget.cat['description'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 5),
            widget.admin
                ? ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 139, 2, 2)),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Delete',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          Padding(padding: EdgeInsets.all(5)),
                          Icon(
                            Icons.delete,
                            size: 20,
                            color: (Colors.white),
                          )
                        ]),
                    onPressed: () {
                      delete();
                    },
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
