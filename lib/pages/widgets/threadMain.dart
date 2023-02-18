import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:irecycle/models/threadItem.dart';
import 'package:irecycle/pages/widgets/writePost.dart';

import 'package:irecycle/common/utils.dart';

class ThreadMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ThreadMain();
}

String userName = '';
String userPP = '';

class _ThreadMain extends State<ThreadMain> {
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
                snapshot.data!.docs.length > 0
                    ? ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .where((doc) =>
                                (doc.data() as Map<String, dynamic>)
                                        .containsKey('state') ==
                                    true &&
                                doc['state'] == true)
                            .map((DocumentSnapshot data) {
                          return ThreadItem(
                            data: data,
                            isFromThread: true,
                            likeCount: data['postLikeCount'],
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
                                'There are no posts',
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

      floatingActionButton: FloatingActionButton(
        onPressed: _writePost,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
