import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Comments extends StatelessWidget {
  final String postID;
  final String userID;

  Comments({super.key, required this.postID, required this.userID});
  TextEditingController commentController = TextEditingController();
  buildComments() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('thread')
          .doc(postID)
          .collection('comments')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('no comment');
        }
        List<Comment> comments = [];

        snapshot.data!.docs.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addComment() {
    FirebaseFirestore.instance
        .collection('thread')
        .doc(postID)
        .collection('comments')
        .add({
      "userName": FirebaseAuth.instance.currentUser!.email,
      "comment": commentController.text,
      "userId": FirebaseAuth.instance.currentUser!.uid,
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Column(children: <Widget>[
        Expanded(child: buildComments()),
        Divider(),
        ListTile(
          title: TextFormField(
            controller: commentController,
            decoration: InputDecoration(labelText: "Write a comment..."),
          ),
          trailing: OutlinedButton(
              onPressed: () {
                addComment();
              },
              child: Text("post")),
        )
      ]),
    );
  }
}

class Comment extends StatelessWidget {
  final String userName;
  final String comment;
  final String userID;
  Comment({
    required this.comment,
    required this.userID,
    required this.userName,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      comment: doc['comment'],
      userID: doc['userId'],
      userName: doc['userName'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
            child: Container(
                width: 48,
                height: 48,
                child: Image.asset('assets/images/download.png')),
          ),
          subtitle: Text(""),
        ),
        Divider(),
      ],
    );
  }
}
