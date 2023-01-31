import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:irecycle/common/utils.dart';
import 'package:irecycle/pages/widgets/editPost.dart';

class ProfileThreadItem extends StatefulWidget {
  final BuildContext parentContext;
  final DocumentSnapshot data;

  final bool isFromThread;
  final int commentCount;
  ProfileThreadItem(
      {required this.data,
      required this.isFromThread,
      required this.commentCount,
      required this.parentContext});

  @override
  State<StatefulWidget> createState() => _ProfileThreadItem();
}

class _ProfileThreadItem extends State<ProfileThreadItem> {
  @override
  void initState() {
    super.initState();
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
              'Delete Profile',
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            content: Text(
              'Are you sure you want to delete your profile ?',
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
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: _showDialog,
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                              color: Color.fromARGB(255, 139, 2, 2),
                            ),
                          )
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
                                        postId: widget.data['postID'],
                                      );
                                    },
                                  ),
                                )),
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: Color.fromARGB(255, 139, 2, 2),
                            ),
                          )
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
