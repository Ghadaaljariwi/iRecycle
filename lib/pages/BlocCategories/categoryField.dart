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
import 'package:image_cropper/image_cropper.dart';
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

class CategoryField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryFieldState();
  }
}

class _CategoryFieldState extends State<CategoryField> {
  TextEditingController NameController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  // final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  File? image;
  String cid = Utils.getRandomString(8) + Random().nextInt(500).toString();

  void add() {
    /*
    var object = category(
      name: NameController.text,
      description: DescriptionController.text,
      // image: image
    );
    //context.read<CategoryBloc>().add(AddCategory(object: object));
*/
    addCategoryDB(NameController.text, DescriptionController.text, image);
    showToastMessage("The category has been added successfully");
    Navigator.pop(context);
  }

  Future addCategoryDB(String name, String description, File? image) async {
    var uuid = Uuid();
    String u = uuid.v4();
    String postImageURL = '';
    if (image != null) {
      postImageURL = (await FBStorage.uploadPostImages(
          postID: u.substring(0, 8), postImageFile: image));
    }
    final firebaseUser = await FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance
        .collection('categories')
        .doc(u.substring(0, 8))
        .set({
      'id': u.substring(0, 8),
      'name': name,
      'description': description,
      'image': postImageURL,
    });
  }

  void showPopUp() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Empty Fields",
              style: TextStyle(color: Colors.lightGreen, fontSize: 20),
            ),
            content: Text(
              "Please enter all required fields",
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

  void validate() {
    if (NameController.text.isEmpty ||
        DescriptionController.text.isEmpty ||
        image == null) {
      showPopUp();
    } else {
      add();
    }
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
    pickImage(source);
    print(cameraStatus);
    if (await cameraStatus.isGranted) {
      pickImage(source);
    } else {
      showToastMessage("We need to access your camera");
      await Permission.camera.request();
    }
  }

  Future pickImage(ImageSource source) async {
    /*
    if (Platform.isAndroid) {
      var cameraStatus = Permission.camera.status;
      pickImage(source);
      print(cameraStatus);
      if (await cameraStatus.isGranted) {
        pickImage(source);
      } else {
        showToastMessage("We need to access your camera");
        await Permission.camera.request();
      }
    }
    */
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
/*
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: img.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
*/
      final ImageTemporary = File(img.path);
      setState(() {
        image = ImageTemporary;
      });
    } on Exception catch (e) {
      showToastMessage('Failed to pick image: $e');
    }
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
              'Are you sure you want to discard this category ?',
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
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Adding Category",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
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
                Theme.of(context).colorScheme.secondary,
              ])),
        ),
      ),
      body: Stack(
        children: <Widget>[
          //KeyboardActions(
          //config: _buildConfig(context),
          Column(
            children: <Widget>[
              Container(
                  //    width: size.width,
                  //  height: size.height -
                  //    MediaQuery.of(context).viewInsets.bottom -
                  //  80,
                  child: Padding(
                padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      autofocus: mounted,
                      focusNode: writingTextFocus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Category Name',
                        hintMaxLines: 4,
                      ),
                      controller: NameController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    TextFormField(
                      //autofocus: mounted,
                      //focusNode: writingTextFocus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Category Description',
                        hintMaxLines: 10,
                      ),
                      controller: DescriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    image != null
                        ? Center(
                            child: Image.file(
                              image!,
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          )
                        : SizedBox(
                            height: 20,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => checkPermission(ImageSource.gallery),
                          iconSize: 30,
                          color: Color.fromARGB(255, 65, 102, 39),
                          icon: const Icon(Icons.photo_library_outlined),
                          padding: EdgeInsets.only(right: 30),
                        ),
                        IconButton(
                            onPressed: () =>
                                checkPermission(ImageSource.camera),
                            iconSize: 30,
                            color: Color.fromARGB(255, 65, 102, 39),
                            icon: const Icon(Icons.photo_camera)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: validate,
                          child: Text('Add'),
                        )
                      ],
                    ),
                  ],
                ),
              )),
            ],
          ),
          //),
        ],
      ),
    );
    // },
    //);
  }
}
