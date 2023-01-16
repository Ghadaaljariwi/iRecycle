import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/pages/Bloc/Post.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';
import '../common/theme_helper.dart';
import 'Bloc/home_bloc.dart';
import 'Bloc/home_event.dart';
import 'Bloc/home_state.dart';
import 'registration_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Bloc extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlocState();
  }
}

class _BlocState extends State<Bloc> {
  late HomeBloc bloc;

  void initState() {
    // TODO: implement initState
    _getUserDetail();
    super.initState();
    bloc = context.read<HomeBloc>();
  }

  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  TextEditingController nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  File? image;

  _getUserDetail() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      nameController.text = snapshot.get("firstName");
      image = File(snapshot.get('image')) as File?;
      _emailController.text = snapshot.get("email");
      setState(() {});
    });
  }

  Future delete() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return LoginPage();
    }));
    showToastMessage("Account deleted successfully");
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

  checkPermission(ImageSource source) async {
    var cameraStatus = Permission.camera.status;
    print(cameraStatus);
    if (await cameraStatus.isGranted) {
      pickImage(source);
    } else {
      showToastMessage("We need to access your camera");
      await Permission.camera.request();
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final ImageTemporary = File(image.path);
      setState(() {
        this.image = ImageTemporary;
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"image": ImageTemporary.path}, SetOptions(merge: true)).then(
              (value) {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget _buildFoodCard(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              child: Image.network(
                post.thumbnailURL,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.name,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                            ),
                            child: Text(
                              post.price,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 0,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const CircularProgressIndicator();
            }
            if (state is HomeSuccessFetchDataState) {
              return Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildFoodCard(state.posts[index]);
                  },
                  itemCount: state.posts.length,
                ),
              );
            }
            if (state is HomeErrorFetchDataState) {
              return Center(
                child: Column(
                  children: [
                    Text(state.errorMessage),
                    ElevatedButton(
                      child: const Text("Fetch Data"),
                      onPressed: () {
                        bloc.add(FetchDataEvent());
                      },
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: ElevatedButton(
                child: const Text("Fetch Data"),
                onPressed: () {
                  bloc.add(FetchDataEvent());
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
