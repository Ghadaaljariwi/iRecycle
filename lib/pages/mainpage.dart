import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/pages/profile_page.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';
import 'package:irecycle/writePost.dart';

import '../common/theme_helper.dart';
import 'registration_page.dart';

class MainPage extends StatefulWidget {

  @override State<StatefulWidget> createState() => _MainPageState();



}

class _MainPageState extends State<MainPage> {


  TextEditingController nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
void _writePost() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WritePost()));
  }
  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      nameController.text = snapshot.get("firstName");
      // image = snapshot.get('image');
      _emailController.text = snapshot.get("email");
      setState(() {});
    });
  }


  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white,
        // backgroundColor: Colors.red,
        fontSize: 16.0);
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ])),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(
              children: <Widget>[
                // Icon(Icons.notifications),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 130, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.email.toString(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'login successfully',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
   
    floatingActionButton: FloatingActionButton(
        onPressed: _writePost,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ),
    );
  }
}
