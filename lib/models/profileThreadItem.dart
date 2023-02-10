import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:irecycle/common/utils.dart';
import 'package:irecycle/pages/widgets/contentDetailProfile.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/FBCloudStore.dart';
import '../controllers/FBStorage.dart';

List pubLikeList = [];

class ProfileThreadItem extends StatefulWidget {
  final BuildContext parentContext;
  final DocumentSnapshot data;

  final bool isFromThread;
  final int commentCount;
  final int likeCount;

  ProfileThreadItem(
      {required this.data,
      required this.isFromThread,
      required this.likeCount,
      required this.commentCount,
      required this.parentContext});

  @override
  State<StatefulWidget> createState() => _ProfileThreadItem();
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

class _ProfileThreadItem extends State<ProfileThreadItem> {
  @override
  late int _likeCount;
  void initState() {
    _likeCount = widget.data['postLikeCount'];
    super.initState();
  }

  void _updateLikeCount(bool isLikePost) async {
    if (isLikePost) {
      setState(() {
        pubLikeList.remove(widget.data['postID']);
        print(pubLikeList);
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.data['userID'])
          .update({'likeList': pubLikeList});

      DocumentReference likeReference = FirebaseFirestore.instance
          .collection('thread')
          .doc(widget.data['postID'])
          .collection('like')
          .doc(widget.data['userID']);

      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(likeReference);
      });
    } else {
      setState(() {
        pubLikeList.add(widget.data['postID']);
        print(pubLikeList);
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.data['userID'])
          .update({'likeList': pubLikeList});
      await FirebaseFirestore.instance
          .collection('thread')
          .doc(widget.data['postID'])
          .collection('like')
          .doc(widget.data['userID'])
          .set({
        'userName': widget.data['userID'],
      });
    }

    FirebaseFirestore.instance
        .collection('thread')
        .doc(widget.data['postID'])
        .update({'postLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});

    setState(() {
      isLikePost ? _likeCount-- : _likeCount++;
    });
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
            onPressed: () {
              delete();
            },
          );

          return AlertDialog(
            title: Text(
              'Delete Post',
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            content: Text(
              'Are you sure you want to delete this post ?',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              cancelButton,
              continueButton,
            ],
          );
        });
  }

  void delete() {
    deletePostDB();
  }

  Future deletePostDB() async {
    await FirebaseFirestore.instance
        .collection('thread')
        .doc(widget.data['postID'])
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.isFromThread
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContentDetailProfile(
                        postData: widget.data,
                      )))
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 6),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                        child: Container(
                            width: 48,
                            height: 48,
                            child: Image.asset('assets/images/download.png')),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              widget.data['userName'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                /////////////////
                //contnet
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 4, 10),
                    child: Text(
                      (widget.data['postContent'] as String).length > 200
                          ? '${widget.data['postContent'].substring(0, 132)} ...'
                          : widget.data['postContent'],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
                widget.data['postImage'] != ''
                    ? GestureDetector(
                        onTap: () {},
                        child: Utils.cacheNetworkImageWithEvent(
                            context, widget.data['postImage'], 0, 0))
                    : Container(),
                Divider(
                  height: 2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //likes
                      /*
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.thumb_up, size: 18, color: Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '0',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //comments
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.mode_comment, size: 18),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Comment ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    */
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => _updateLikeCount(
                                  pubLikeList != null &&
                                          pubLikeList
                                              .contains(widget.data['postID'])
                                      ? true
                                      : false),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(left: 4)),
                                  Icon(Icons.thumb_up,
                                      size: 18,
                                      color: pubLikeList
                                              .contains(widget.data['postID'])
                                          ? Colors.blue[900]
                                          : Colors.black),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      '(${_likeCount})',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: pubLikeList.contains(
                                                  widget.data['postID'])
                                              ? Colors.blue[900]
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(PageRouteBuilder(
                                //       //fullscreenDialog: true,
                                //       pageBuilder: (BuildContext context, _, __) =>
                                //           Comments(
                                //         postID: widget.data['postID'],
                                //         userID: widget.data['userID'],
                                //       ),
                                //     ));
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(left: 4)),
                                  GestureDetector(
                                    /* onTap:() => showComments(
    context,
    postId: widget.data['postID'],
    ownerId: widget.data['userID'],
    ),*/
                                    onTap: () {},
                                    child: Icon(Icons.mode_comment, size: 18),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      '(${widget.commentCount})',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      /////
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: _showDialog,
                              icon: Icon(
                                Icons.delete,
                                size: 18,
                                color: Color.fromARGB(255, 139, 2, 2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: (() => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return EditPost(
                                          data: widget.data,
                                        );
                                      },
                                    ),
                                  )),
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                                color: Color.fromARGB(255, 139, 2, 2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditPost extends StatefulWidget {
  final DocumentSnapshot data;
// here data carried
  EditPost({required this.data});
  @override
  State<StatefulWidget> createState() => _EditPost();
}

class _EditPost extends State<EditPost> {
  TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;
  String postId = '';
  String name = '';
  String postContet = '';
  String post = '';
  File? _postImageFile;

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
        ),
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
          postId, name, writingTextController.text, post);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    postId = widget.data['postID'];
    name = widget.data['userName'];
    //_postImageFile = File(widget.data['postImage']);
    post = widget.data['postImage'];
    writingTextController.text = widget.data['postContent'];
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

/*
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
*/
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
      pubLikeList = snapshot.get("likeList");
      name = snapshot.get("firstName");
      // image = snapshot.get('image');
      setState(() {});
    });
  }

  ImagePicker() {}
}
