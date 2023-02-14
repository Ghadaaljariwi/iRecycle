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
              //.where('state', isEqualTo: 'False')
              .orderBy('postTimeStamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return Stack(
              children: <Widget>[
                snapshot.hasData
                    ? ListView(
                        shrinkWrap: true,
                        children:
                            snapshot.data!.docs.map((DocumentSnapshot data) {
                          return AdminThreadItem(
                            data: data,
                            isFromThread: true,
                            commentCount: data['postCommentCount'],
                            parentContext: context,
                          );
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
