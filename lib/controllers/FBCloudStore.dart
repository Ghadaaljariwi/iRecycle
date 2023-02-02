import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:irecycle/common/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBCloudStore {
  static Future<void> sendPostInFirebase(String postID, String name,
      String postContent, String postImageURL) async {
    await FirebaseFirestore.instance.collection('thread').doc(postID).set({
      'postID': postID,
      'userName': name,
      'userThumbnail': 'my photo',
      'userID': FirebaseAuth.instance.currentUser!.uid,
      'postTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'postContent': postContent,
      'postImage': postImageURL,
      'postLikeCount': 0,
      'postCommentCount': 0,
      'state': false,
    });

    print("good");
  }
}
