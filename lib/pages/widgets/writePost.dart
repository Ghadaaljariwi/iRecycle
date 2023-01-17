import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:irecycle/common/utils.dart';
import 'package:irecycle/controllers/FBCloudStore.dart';
import 'package:irecycle/controllers/FBStorage.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:cross_file/cross_file.dart';

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
    } else {

      Navigator.pop(context);
      String postID =
          Utils.getRandomString(8) + Random().nextInt(500).toString();
      String postImageURL = '';

      postImageURL = (await FBStorage.uploadPostImages(
          postID: postID, postImageFile: _postImageFile!));

      FBCloudStore.sendPostInFirebase(
          postID,
          writingTextController.text,
          //widget.myData,
          postImageURL);

      setState(() {
        _isLoading = false;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
    final ImagePicker _picker = ImagePicker();
    final imageFileFromGallery =
        await _picker.pickImage(source: ImageSource.gallery);

    File? cropImageFile = File(imageFileFromGallery!.path);
    cropImageFile = await Utils.cropImageFile(
        cropImageFile); //await cropImageFile(imageFileFromGallery);
    setState(() {
      _postImageFile = cropImageFile;
    });
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
