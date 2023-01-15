import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:irecycle/common/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBCloudStore {
  static Future<void> sendPostInFirebase(
      String postID, String postContent, String postImageURL) async {
    print(postContent);

    print(postID);
    print(postImageURL);
    print("can you see");

    print("here");
    String name;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
     name = snapshot.get("firstname");
     
      // image = snapshot.get('image');
      
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('thread')
        .doc(postID)
        .set({
      'postID': postID,
      'userName': 'name',
      'userThumbnail': 'my photo',
      'postContent': postContent,
      'postImage': postImageURL,
      'postLikeCount': 0,
      'postCommentCount': 0,
    });
    
    print("good");
  }
}
