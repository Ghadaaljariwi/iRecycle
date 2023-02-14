import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/pages/BlocCategories/addCategory.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../../common/utils.dart';
import '../../controllers/FBStorage.dart';
import 'bloc/category_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'category.dart';
import 'cat.dart';

class CategoryDetail extends StatefulWidget {
  final DocumentSnapshot cat;

  CategoryDetail({required this.cat});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Details'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
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
            SizedBox(height: 20),
            Text(
              widget.cat['name'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: Text(
                widget.cat['description'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
