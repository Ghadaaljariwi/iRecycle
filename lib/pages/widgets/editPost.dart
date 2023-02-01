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
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:cross_file/cross_file.dart';
import 'package:permission_handler/permission_handler.dart';

final String postId = '';

class EditPost extends StatefulWidget {
// here data carried
  EditPost({required postId});
  @override
  State<StatefulWidget> createState() => _EditPost();
}

class _EditPost extends State<EditPost> {
  TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;

  File? _postImageFile;
  String name = '';
  void initState() {
    _getUserDetail();
    super.initState();
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        textColor: Colors.white,
        fontSize: 16.0);
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

      String postImageURL = '';
      if (_postImageFile != null) {
        postImageURL = (await FBStorage.uploadPostImages(
            postID: postId, postImageFile: _postImageFile!));
      }

      FBCloudStore.sendPostInFirebase(
          postId, '', writingTextController.text, postImageURL);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(postId);
    showToastMessage(postId);
    showToastMessage('test editing');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        centerTitle: true,
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => _postToFB(),
              child: Text(
                'Save',
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
