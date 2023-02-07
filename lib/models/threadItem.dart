import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:irecycle/common/utils.dart';
import 'package:irecycle/models/Comments.dart';
import 'package:irecycle/pages/widgets/contentDetail.dart';

import '../pages/widgets/contentDetailProfile.dart';

class ThreadItem extends StatefulWidget {
  final BuildContext parentContext;
  final DocumentSnapshot data;

  final bool isFromThread;
  final int commentCount;
  final int likeCount;
  ThreadItem(
      {required this.data,
      required this.isFromThread,
      required this.likeCount,
      required this.commentCount,
      required this.parentContext});

  @override
  State<StatefulWidget> createState() => _ThreadItem();
}

List pubLikeList = [];

class _ThreadItem extends State<ThreadItem> {
  @override
  late int _likeCount;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  void initState() {
    _likeCount = widget.data['postLikeCount'];
    //  _getUserDetail();
    super.initState();
  }

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      pubLikeList = snapshot.get("likeList");
      // image = snapshot.get('image');
      setState(() {});
    });
  }

  follow(data) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('following')
        .add({
      "userName": data,
      "userId": FirebaseAuth.instance.currentUser!.uid,
    });
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

  Widget page() {
    if (uid == widget.data['userID']) {
      return ContentDetailProfile(
        postData: widget.data,
      );
    } else {
      return ContentDetail(
        postData: widget.data,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.isFromThread
          ? Navigator.push(
              context, MaterialPageRoute(builder: (context) => page()))
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
                  onTap: () => widget.isFromThread
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContentDetail(
                                    postData: widget.data,
                                  )))
                      : null,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                        child: Container(
                            width: 48, // MediaQuery.of(context).size.width,
                            height: 48, //MediaQuery.of(context).size.height,
                            child: Image.asset('assets/images/download.png')),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Text(
                                  widget.data['userName'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (widget.data['userID'] !=
                                  FirebaseAuth.instance.currentUser!.uid)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: TextButton(
                                    onPressed: () {
                                      follow(widget.data['userName']);
                                    },
                                    child: Text(
                                      'follow',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                            ],
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
                GestureDetector(
                  onTap: () => widget.isFromThread
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContentDetail(
                                    postData: widget.data,
                                  )))
                      : null,
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
                        onTap: () => widget.isFromThread
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContentDetail(
                                          postData: widget.data,
                                        )))
                            : null,
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
                      GestureDetector(
                        onTap: () => _updateLikeCount(pubLikeList != null &&
                                pubLikeList.contains(widget.data['postID'])
                            ? true
                            : false),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.thumb_up,
                                size: 18,
                                color:
                                    pubLikeList.contains(widget.data['postID'])
                                        ? Colors.blue[900]
                                        : Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Like ( ${_likeCount} )',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: pubLikeList
                                            .contains(widget.data['postID'])
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Comment ( ${widget.commentCount} )',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
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
