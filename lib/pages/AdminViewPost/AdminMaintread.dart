import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:irecycle/pages/AdminViewPost/Adminitem.dart';

import 'package:irecycle/pages/widgets/writePost.dart';

import 'package:irecycle/common/utils.dart';

class AdminThreadMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminThreadMain();
}

String userName = '';
String userPP = '';

class _AdminThreadMain extends State<AdminThreadMain> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _getUserDetail();

    // getToken();
  }

  void _writePost() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WritePost()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('thread')
              .orderBy('postTimeStamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return Stack(
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs
                      .where((doc) =>
                          (doc.data() as Map<String, dynamic>)
                                  .containsKey('state') ==
                              true &&
                          doc['state'] == false)
                      .map((DocumentSnapshot data) {
                    return AdminThreadItem(
                      data: data,
                      isFromThread: true,
                      commentCount: data['postCommentCount'],
                      parentContext: context,
                    );
                  }).toList(),
                ),
                Utils.loadingCircle(_isLoading),
              ],
            );
          }),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      userName = snapshot.get("firstName");
      // userimage = snapshot.get('image');
      setState(() {});
    });
  }

  void _moveToContentDetail(DocumentSnapshot data) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ContentDetail(
    //
    //             )));
  }
}
