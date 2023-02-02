import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:irecycle/controllers/FBCloudStore.dart';
import 'package:irecycle/common/utils.dart';
import 'package:irecycle/models/Comments.dart';
import 'package:irecycle/models/threaditem.dart';

class ContentDetail extends StatefulWidget {
  final DocumentSnapshot postData;
  ContentDetail({
    required this.postData,
  });
  @override
  State<StatefulWidget> createState() => _ContentDetail();
}

class _ContentDetail extends State<ContentDetail> {
  final TextEditingController _msgTextController = new TextEditingController();

  FocusNode _writingTextFocus = FocusNode();
  String userName = '';
  @override
  void initState() {
    _getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Post Detail'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('thread')
                .doc(widget.postData['postID'])
                .collection('comments')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ThreadItem(
                                  data: widget.postData,
                                  isFromThread: false,
                                  commentCount: snapshot.data!.docs.length,
                                  parentContext: context,
                                ),
                                snapshot.data!.docs.length > 0
                                    ? ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children:
                                            snapshot.data!.docs.map((document) {
                                          return Comments(
                                              data: document, size: size);
                                        }).toList(),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildTextComposer()
                ],
              );
            }));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _msgTextController,
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Write a comment"),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 2.0),
                child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () {
                      _handleSubmitted(_msgTextController.text);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      userName = snapshot.get("firstName");
      setState(() {});
    });
  }

  Future<void> _handleSubmitted(String text) async {
  

    try {
      FirebaseFirestore.instance
          .collection('thread')
          .doc(widget.postData['postID'])
          .collection('comments')
          .add({
        "userName": userName,
        "comment": _msgTextController.text,
        "userId": FirebaseAuth.instance.currentUser!.uid,
      });

      widget.postData.reference
          .update({'postCommentCount': FieldValue.increment(1)});
      FocusScope.of(context).requestFocus(FocusNode());
      _msgTextController.text = '';
    } catch (e) {
      print('error to submit comment');
    }
  }
}
