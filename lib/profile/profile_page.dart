import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/utils.dart';
import '../models/profileThreadItem.dart';
import '../models/threadItem.dart';
import '../pages/registration_page.dart';
import 'package:irecycle/profile/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String userName = '';
  String userImage = '';
  final _controller = PageController();

  @override
  void initState() {
    // TODO: implement initState

    _getUserDetail();
    super.initState();
  }

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      uid = FirebaseAuth.instance.currentUser!.uid;
      userName = snapshot.get("firstName");
      userImage = snapshot.get('image');
      setState(() {});
    });
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(
                currentUserId: FirebaseAuth.instance.currentUser!.uid)));
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hey',
                  style: TextStyle(
                    fontSize: 77,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
      
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.black,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 4.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('thread')
                  .orderBy('postTimeStamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return Column(
                  children: <Widget>[
                    snapshot.data!.docs.length > 0
                        ? ListView(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),

                            children: snapshot.data!.docs
                                .map((DocumentSnapshot data) {
                              if (uid == data['userID']) {
                                return ProfileThreadItem(
                                  data: data,
                                  isFromThread: true,
                                  likeCount: data['postLikeCount'],
                                  commentCount: data['postCommentCount'],
                                  parentContext: context,
                                );
                              } else {
                                return Utils.loadingCircle(_isLoading);
                              }
                            }).toList(),
                          )
                        : Container(
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.error,
                                  color: Colors.grey[700],
                                  size: 64,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    'There is no post',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )),
                          ),
                    Utils.loadingCircle(_isLoading),
                  ],
                );
              }),
        ),
      ],
    ),
      ),
    );
  }
}
