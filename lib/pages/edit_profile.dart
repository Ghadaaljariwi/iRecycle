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
import 'package:irecycle/pages/profile_page.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/theme_helper.dart';
import '../common/utils.dart';
import '../controllers/FBStorage.dart';
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
  File? image;
  //User user;

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      nameController.text = snapshot.get("firstName");
      image = File(snapshot.get('image'));
      _emailController.text = snapshot.get("email");
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserDetail();
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

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

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

  Column buildPictureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        image != null
            ? Center(
                child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      image!.path,
                    )),
              )
            : const CircleAvatar(
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
                */
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
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
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
                      buildPictureField(),
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
