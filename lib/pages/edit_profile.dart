import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:irecycle/main.dart';
import 'package:irecycle/models/user.dart';
import 'package:irecycle/pages/home.dart';
import '';

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
import 'package:irecycle/pages/widgets/progress.dart';

import '../common/theme_helper.dart';
import 'registration_page.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //currentUserId= FirebaseAuth.instance.currentUser!.uid;

  EditProfile({currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  //User user;

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

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await _getUserDetail();
    //user = User.fromDocument(doc);
    //displayNameController.text = user.displayName;
    //bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "Update Name",
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Email",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Update Email",
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body:  ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        // child: CircleAvatar(
                        //   radius: 50.0,
                        //   backgroundImage: ("url.url"),
                        // ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => print('update profile data'),
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          onPressed: () => print('logout'),
                          icon: Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            "Logout",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
