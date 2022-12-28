/*import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';

//import '../common/theme_helper.dart';
import 'package:irecycle/pages/registration_page.dart';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  ProfileBloc() : super();

  @override
  ProfileState get initialState => ProfileLoading();

  //   _getUserDetail() {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((DocumentSnapshot snapshot) {
  //     nameController.text = snapshot.get("firstName");
  //     // image = snapshot.get('image');
  //     _emailController.text = snapshot.get("email");
  //     setState(() {});
  //   });
  // }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      try {
        final User user = _auth.currentUser;
        final DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        final String name = snapshot.get('firstName');
        final String email = snapshot.get('email');
        yield ProfileLoaded(name: name, email: email);
      } catch (error) {
        yield ProfileError(error: error.toString());
      }
    }
  }
}


// class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   TextEditingController nameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();

//   ProfileBloc() : super(ProfileLoading()) {
//     // Initialize repository and transformer
//     final repository = _firestore.collection('users');
//     final transformer =
//         (snapshot) => snapshot.documents.map((doc) => doc.data).toList();

//     // Add transformer and repository to super constructor
//     super.add(repository
//         .snapshots()
//         .transform(transformer)
//         .map((event) => LoadProfile())
//         .cast<ProfileEvent>());
//   }

//   _getUserDetail() {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .snapshots()
//         .listen((DocumentSnapshot snapshot) {
//       nameController.text = snapshot.get("firstName");
//       // image = snapshot.get('image');
//       _emailController.text = snapshot.get("email");
//       setState(() {});
//     });
//   }

//   @override
//   Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
//     if (event is LoadProfile) {
//       yield ProfileLoading();
//       // Get current user's ID
//       final user = _auth.currentUser;
//       if (user != null) {
//         // Fetch user's profile data from Firebase
//         final data = _getUserDetail();
//         yield ProfileLoaded(
//           name: data['firstName'],
//           email: data['email'],
//         );
//       } else {
//         yield ProfileError('No user is currently signed in');
//       }
//     }
//   }
// }*/
