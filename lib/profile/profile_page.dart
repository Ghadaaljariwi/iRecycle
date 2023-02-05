import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';

import '../common/theme_helper.dart';
import 'package:flutter/material.dart';
import '../common/utils.dart';
import '../models/profileThreadItem.dart';
import '../models/threadItem.dart';
import '../pages/registration_page.dart';
import 'package:irecycle/profile/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String userName = '';
  String userImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetail();
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
  }

  void _saveChanges(String name, String email) {
// Save the changes to the database.
    FirebaseAuth.instance.currentUser?.updateProfile(displayName: name);
    FirebaseAuth.instance.currentUser?.updateEmail(email);

    setState(() {
      _isEditing = false;
    });
  }

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      uid = FirebaseAuth.instance.currentUser!.uid;
      userName = snapshot.get("firstName");
      userImage = snapshot.get('image');
      setState(() {});
    });
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(
                currentUserId: FirebaseAuth.instance.currentUser!.uid)));
  }

  buildProfileButton() {
    return buildButton(text: "Edit Profile", function: editProfile);
  }

  Container buildButton(
      {required String text, required void Function() function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        onPressed: function,
        child: Container(
          width: 240.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            border: Border.all(
              color: Theme.of(context).primaryColorLight,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileHeader() {
    return FutureBuilder(
      //future: usersRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        // if (!snapshot.hasData) {
        //   return circularProgress();
        // }
        // User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      userImage,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCountColumn("posts", 0),
                            buildCountColumn("followers", 0),
                            buildCountColumn("following", 0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 4.0),
                child: StreamBuilder<QuerySnapshot>(
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
                                      .map((DocumentSnapshot data) {
                                    if (uid == data['userID']) {
                                      return ProfileThreadItem(
                                        data: data,
                                        isFromThread: true,
                                        likeCount: data['postLikeCount'],
                                        commentCount: data['postCommentCount'],
                                        parentContext: context,
                                      );
                                    } else {
                                      return Utils.loadingCircle(_isLoading);
                                    }
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
                                          'There is no post',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700]),
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
              ),
            ],
          ),
        );
      },
    );
  }

  Scaffold streamBuild() {
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
                          children:
                              snapshot.data!.docs.map((DocumentSnapshot data) {
                            if (uid == data['userID']) {
                              return ProfileThreadItem(
                                data: data,
                                isFromThread: true,
                                likeCount: data['postLikeCount'],
                                commentCount: data['postCommentCount'],
                                parentContext: context,
                              );
                            } else {
                              return Utils.loadingCircle(_isLoading);
                            }
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
                                  'There is no post',
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
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[buildProfileHeader()],
        ),
      ),
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
// Add the profile picture and name.
            Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    
// Add the profile picture.
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                    ),
// Add the user's name below the profile picture.
                    Text(
                      FirebaseAuth.instance.currentUser!.email.toString(),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
// Add the edit form.
            Container(
              margin: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
// Add the name field.
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
// Add the email field.
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
// Add the save and cancel buttons.
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
// Add the cancel button.
                          ElevatedButton(
                            onPressed: _cancelEdit,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
// Add the save button.
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() == true) {
                                _saveChanges(
                                    nameController.text, emailController.text);
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_isEditing
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              child: Icon(Icons.edit),
            )
          : null,
    );
  }
}
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   bool _isEditing = false;

//   void _cancelEdit() {
//     setState(() {
//       _isEditing = false;
//     });
//   }

//   void _saveChanges(String name, String email) {
//     // Save the changes to the database.
//     FirebaseAuth.instance.currentUser?.updateProfile(displayName: name);
//     FirebaseAuth.instance.currentUser?.updateEmail(email);

//     setState(() {
//       _isEditing = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       floatingActionButton: !_isEditing
//           ? FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   _isEditing = true;
//                 });
//               },
//               child: Icon(Icons.edit),
//             )
//           : null,
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Container(
//               height: 100,
//               child: HeaderWidget(100, false, Icons.house_rounded),
//             ),
//             Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.fromLTRB(25, 130, 25, 10),
//               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//               child: Column(
//                 children: <Widget>[
//                   // Add the profile picture and name.
//                   Container(
//                     height: 200,
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Add the profile picture.
//                           Container(
//                             height: 80,
//                             width: 80,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 3,
//                               ),
//                             ),
//                           ),
//                           // Add the user's name below the profile picture.
//                           Text(
//                             FirebaseAuth.instance.currentUser!.email.toString(),
//                             style: TextStyle(
//                                 fontSize: 22, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Add the user's bio and contact information.
//                   SizedBox(height: 8),
//                   // Row(
//                   //   children: <Widget>[
//                   //     Icon(FontAwesomeIcons.phone),
//                   //     SizedBox(width: 8),
//                   //     Text(
//                   //       FirebaseAuth.instance.currentUser!.email.toString(),
//                   //       style: TextStyle(
//                   //           fontSize: 22, fontWeight: FontWeight.bold),
//                   //     ),
//                   //   ],
//                   // ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Bio:',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Insert bio here',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Contact Information:',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Insert contact information here',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   // Add the edit form.
//                   _isEditing
//                       ? Form(
//                           key: formKey,
//                           child: Column(
//                             children: <Widget>[
//                               TextFormField(
//                                 controller: nameController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Name',
//                                 ),
//                                 validator: (value) {
//                                   if (value?.isEmpty == true) {
//                                     return 'Please enter your name';
//                                   }

//                                   return null;
//                                 },
//                               ),
//                               TextFormField(
//                                 controller: emailController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Email',
//                                 ),
//                                 validator: (value) {
//                                   if (value?.isEmpty == true) {
//                                     return 'Please enter your email';
//                                   }

//                                   return null;
//                                 },
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: <Widget>[
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       if ((formKey.currentState?.validate() ==
//                                           true)) {
//                                         _saveChanges(nameController.text,
//                                             emailController.text);
//                                       }
//                                     },
//                                     // onPressed: () {
//                                     //   if (formKey.currentState.validate()) {
//                                     //     _saveChanges(nameController.text,
//                                     //         emailController.text);
//                                     //   }
//                                     // },
//                                     child: Text('Save'),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: _cancelEdit,
//                                     child: Text('Cancel'),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ))
//                       : Container(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }









// // }[
// //                   Text(
// //                     FirebaseAuth.instance.currentUser!.email.toString(),
// //                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(
// //                     height: 20,
// //                   ),
// //                   Text(
// //                     'login successfully',
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(
// //                     height: 10,
// //                   ),
// //                 ],
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class EditProfileForm extends StatefulWidget {
// //   final GlobalKey<FormState> formKey;
// //   final TextEditingController nameController;
// //   final TextEditingController emailController;
// //   final VoidCallback onCancel;
// //   final Function(String, String) onSave;

// //   const EditProfileForm({
// //     Key key,
// //     @required this.formKey,
// //     @required this.nameController,
// //     @required this.emailController,
// //     @required this.onCancel,
// //     @required this.onSave,
// //   }) : super(key: key);

// //   @override
// //   _EditProfileFormState createState() => _EditProfileFormState();
// // }

// // class _EditProfileFormState extends State<EditProfileForm> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Form(
// //       key: widget.formKey,
// //       child: Column(
// //         children: <Widget>[
// //           TextFormField(
// //             controller: widget.nameController,
// //             decoration: InputDecoration(labelText: 'Name'),
// //             validator: (value) {
// //               if (value.isEmpty) {
// //                 return 'Please enter your name';
// //               }
// //               return null;
// //             },
// //           ),
// //           TextFormField(
// //             controller: widget.emailController,
// //             decoration: InputDecoration(labelText: 'Email'),
// //             validator: (value) {
// //               if (value.isEmpty) {
// //                 return 'Please enter your email';
// //               }
// //               return null;
// //             },
// //           ),
// //           SizedBox(height: 16),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: <Widget>[
// //               FlatButton(
// //                 onPressed: widget.onCancel,
// //                 child: Text('Cancel'),
// //               ),
// //               FlatButton(
// //                 onPressed: () {
// //                   if (widget.formKey.currentState.validate()) {
// //                     widget.onSave(
// //                       widget.nameController.text,
// //                       widget.emailController.text,
// //                     );
// //                   }
// //                 },
// //                 child: Text('Save'),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

*/
