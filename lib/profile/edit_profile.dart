import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:irecycle/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/profile/profile_page.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/theme_helper.dart';
import '../common/utils.dart';
import '../controllers/FBStorage.dart';
import '../pages/registration_page.dart';

class EditProfile extends StatefulWidget {
  EditProfile();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  File? image;
  //User user;

  @override
  void initState() {
    super.initState();
    _getUserDetail();
    //getUser();
  }

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      nameController.text = snapshot.get("firstName");
      image = File(snapshot.get('image'));
      _emailController.text = snapshot.get("email");
      if (mounted) setState(() {});
    });
  }

  updateProfile() {
    if (_emailController.text.isEmpty || nameController.text.isEmpty) {
      showPopUp("Empty Fields", "Please enter all required fields");
    } else if (!_emailController.text.contains('@')) {
      showPopUp("Invalid E-mail", 'Please enter a valid E-mail address');
    } else {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': nameController.text.toString(),
        'email': _emailController.text.toString()
      }).then((value) {
        showToastMessage("Your profile has been updated successfully");
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        showToastMessage("This E-mail address is already in use");
      });
    }
  }

/*
  getUser() async {
    setState(() {
      isLoading = true;
    });
    //DocumentSnapshot doc = await _getUserDetail();
    //user = User.fromDocument(doc);
    //displayNameController.text = user.displayName;
    //bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }
*/
  void showPopUp(String title, String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: Colors.lightGreen, fontSize: 20),
            ),
            content: Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          );
        });
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

/*
  checkPermission(ImageSource source) async {
    var cameraStatus = Permission.camera.status;
    print(cameraStatus);
    if (await cameraStatus.isGranted) {
      pickImage(source);
    } else {
      showToastMessage("We need to access your camera");
      await Permission.camera.request();
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;

      final ImageTemporary = File(img.path);
      setState(() {
        image = ImageTemporary;
      });
      String postImageURL = (await FBStorage.uploadPostImages(
          postID: FirebaseAuth.instance.currentUser!.uid,
          postImageFile: image as File));
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"image": ImageTemporary.path}, SetOptions(merge: true)).then(
              (value) {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
*/
  Column buildPictureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              'assets/images/download.png',
            )
            /*
                Utils.cacheNetworkImageWithEvent(context, image, 500, 0),
                AssetImage(
                  'assets/images/download.png',
                ),
                
                ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (() => pickImage(ImageSource.gallery)),
                child: Text('Pick Gallery')),
            ElevatedButton(
                onPressed: (() => pickImage(ImageSource.camera)),
                child: Text('Pick Camera')),
          ],
          */
            ),
        SizedBox(
          height: 30,
        ), //
        Divider(
          height: 1,
          color: Colors.black,
        ),
      ],
    );
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

  int count = 0;
  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          // set up the buttons
          Widget cancelButton = TextButton(
            child: Text(
              "No",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            onPressed: Navigator.of(context).pop,
          );
          Widget continueButton = TextButton(
            child: Text(
              "Yes",
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            onPressed: () => Navigator.popUntil(
              context,
              (route) {
                return count++ == 2;
              },
            ),
          );

          return AlertDialog(
            title: Text(
              'Exit',
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            content: Text(
              'Are you sure you want to exit ?',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              cancelButton,
              continueButton,
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            _showDialog();
          },
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          //IconButton(
          /*
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
          */
        ],
      ),
      body:
          //  isLoading
          //     ? circularProgress()
          //    :
          ListView(
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
                      // buildPictureField(),
                      buildDisplayNameField(),
                      buildBioField(),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => updateProfile(),
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
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
