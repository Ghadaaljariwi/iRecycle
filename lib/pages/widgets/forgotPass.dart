import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/common/theme_helper.dart';
import 'package:irecycle/pages/login_page.dart';

class forgotPass extends StatefulWidget {
  const forgotPass({super.key});

  @override
  State<forgotPass> createState() => _forgotPassState();
}

class _forgotPassState extends State<forgotPass> {
  final TextEditingController _emailController = TextEditingController();

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Empty Fields",
              style: TextStyle(color: Colors.lightGreen, fontSize: 20),
            ),
            content: Text(
              "Please enter all required fields",
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          );
        });
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.01, 20, 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 39.0),
                    Image.asset(
                      "assets/images/recycling.png",
                      fit: BoxFit.fitWidth,
                      width: 150,
                      height: 250,
                    ),
                    Container(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: ThemeHelper()
                            .textInputDecoration('Email', 'Enter your email'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 39.0),
                    Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              'Send to email'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            if (_emailController.text.isEmpty) {
                              _showDialog();
                            } else if (_emailController.text.isEmpty) {
                              showToastMessage('Please enter your email');
                            } else if (!_emailController.text.contains('@')) {
                              showToastMessage('Please enter a valid email');
                            } else
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: _emailController.text)
                                  .then((value) {
                                showToastMessage('Reset password email sent successfully');

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              }).onError((error, stackTrace) {
                                showToastMessage("Error ${error.toString()}");
                              });
                          }),
                    ),
                  ],
                ))),
      ),
    );
  }
}
