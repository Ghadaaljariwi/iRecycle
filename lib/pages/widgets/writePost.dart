import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:irecycle/common/utils.dart';
import 'package:irecycle/controllers/FBCloudStore.dart';
import 'package:irecycle/controllers/FBStorage.dart';
import 'package:irecycle/pages/widgets/threadMain.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:cross_file/cross_file.dart';
import 'package:permission_handler/permission_handler.dart';

class WritePost extends StatefulWidget {
// here data carried

  @override
  State<StatefulWidget> createState() => _WritePost();
}

class _WritePost extends State<WritePost> {
  TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;
  File? _postImageFile;
  String name = '';
  int count = 0;
  void initState() {
    _getUserDetail();
    super.initState();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: writingTextFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  print('Select Image');
                  _getImageAndCrop();
                },
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_photo_alternate, size: 28),
                      Text(
                        "Add Image",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  void _postToFB() async {
    setState(() {
      _isLoading = true;
    });
    if (writingTextController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Empty Fields",
                style: TextStyle(color: Colors.lightGreen, fontSize: 20),
              ),
              content: Text(
                "Please enter required fields",
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
    } else {
      Navigator.pop(context);
      String postID =
          Utils.getRandomString(8) + Random().nextInt(500).toString();

      String postImageURL = '';
      if (_postImageFile != null) {
        postImageURL = (await FBStorage.uploadPostImages(
            postID: postID, postImageFile: _postImageFile!));
      }

      FBCloudStore.sendPostInFirebase(
          postID,
          name,
          writingTextController.text,
          //widget.myData,
          postImageURL);

      showToastMessage("The post is under review by the admin");

      setState(() {
        _isLoading = false;
      });
    }
  }

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
              'Are you sure you want to discard this post ?',
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
    final size = MediaQuery.of(context).size;
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
        title: Text('Write Post'),
        centerTitle: true,
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => _postToFB(),
              child: Text(
                'Post',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Stack(
        children: <Widget>[
          KeyboardActions(
            config: _buildConfig(context),
            child: Column(
              children: <Widget>[
                Container(
                    width: size.width,
                    height: size.height -
                        MediaQuery.of(context).viewInsets.bottom -
                        80,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Image(
                                      image: AssetImage(
                                        'assets/images/recycling.png',
                                      ),
                                    ),
                                    // here should be the profile picture
                                    // Image.asset(
                                    //     'assets/images/recycling.png')
                                  ),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                            TextFormField(
                              autofocus: true,
                              focusNode: writingTextFocus,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Writing anything.',
                                hintMaxLines: 4,
                              ),
                              controller: writingTextController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                            _postImageFile != null
                                ? Image.file(
                                    _postImageFile!,
                                    fit: BoxFit.fill,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getImageAndCrop() async {
    /*
    if (Platform.isAndroid) {
      var cameraStatus = Permission.camera.status;
      print(cameraStatus);
      if (await cameraStatus.isGranted) {
        print(cameraStatus);
      } else {
        showToastMessage("We need to access your camera");
        await Permission.camera.request();
      }
    }
    */
    try {
      final ImagePicker _picker = ImagePicker();
      final imageFileFromGallery =
          await _picker.pickImage(source: ImageSource.gallery);

      File? cropImageFile = File(imageFileFromGallery!.path);
      cropImageFile = await Utils.cropImageFile(
          cropImageFile); //await cropImageFile(imageFileFromGallery);
      setState(() {
        _postImageFile = cropImageFile;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  checkPermission(ImageSource source) async {
    var cameraStatus = Permission.camera.status;
    print(cameraStatus);
    if (await cameraStatus.isGranted) {
    } else {
      showToastMessage("We need to access your camera");
      await Permission.camera.request();
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

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      name = snapshot.get("firstName");
      // image = snapshot.get('image');
      setState(() {});
    });
  }
}
