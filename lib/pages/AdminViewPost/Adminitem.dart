import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/common/utils.dart';
import 'package:irecycle/models/Comments.dart';

class AdminThreadItem extends StatefulWidget {
  final BuildContext parentContext;
  final DocumentSnapshot data;

  final bool isFromThread;
  final int commentCount;
  AdminThreadItem(
      {required this.data,
      required this.isFromThread,
      required this.commentCount,
      required this.parentContext});

  @override
  State<StatefulWidget> createState() => _AdminThreadItem();
}

class _AdminThreadItem extends State<AdminThreadItem> {
  @override
  void initState() {
    super.initState();
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

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _updateState(state) {
    widget.data.reference.update({'state': state});
    String str = '';
    if (state == false) {
      str = "declined";
    } else {
      str = "accepted";
    }
    showToastMessage("The post has been " + str + " successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
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
                    GestureDetector(
                      onTap: () => _updateState(false),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.disabled_by_default_outlined,
                              size: 18, color: Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Decline ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            /* onTap:() => showComments(
context,
postId: widget.data['postID'],
ownerId: widget.data['userID'],
),*/
                            onTap: () => _updateState(true),
                            child: Icon(Icons.done_outlined, size: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Accept ',
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
    );
  }
}
