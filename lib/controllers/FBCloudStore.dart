import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:irecycle/common/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBCloudStore {
  static Future<void> sendPostInFirebase(String postID, String postContent,
     String postImageURL) async {
   
    FirebaseFirestore.instance.collection('thread').doc(postID).set({
      'postID': postID,
      'userName': 'sara',
      'userThumbnail': 'my photo',
      'postTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'postContent': postContent,
      'postImage': postImageURL,
      'postLikeCount': 0,
      'postCommentCount': 0,
     
    });
  }

 
  
}
