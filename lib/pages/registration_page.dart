import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:irecycle/common/theme_helper.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future addUserDetails(String name, String email) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set({
      'firstName': name,
      'email': email,
      'image': '',
      'uid': firebaseUser.uid,
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Empty Fields",
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
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
        backgroundColor: Colors.red,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    showToastMessage('hello');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.login),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 170, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Hello!',
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sign up for a new account',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //name

                        Container(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: ThemeHelper()
                                .textInputDecoration('Name', 'Enter your name'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),

                        //email

                        Container(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            /*
                            validator: (val) {
                              if (!(val!.isEmpty) ||
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            */
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),

                        //pasword

                        Container(
                          child: TextFormField(
                            controller: _passController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password", "Enter your password"),
                            /*
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            */
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),

                        //re password

                        Container(
                          child: TextFormField(
                            controller: _repassController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Re-Password", "Re-Enter your password"),
                            /*
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please Re-enter your password";
                              }
                              return null;
                            },
                            */
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_emailController.text.isEmpty &&
                                  _passController.text.isEmpty &&
                                  _repassController.text.isEmpty &&
                                  _nameController.text.isEmpty) {
                                _showDialog();
                              } else if (_nameController.text.isEmpty) {
                                showToastMessage('Please enter your name');
                              } else if (_emailController.text.isEmpty) {
                                showToastMessage('Please enter your email');
                              } else if (!_emailController.text.contains('@')) {
                                showToastMessage('Please enter a valid email');
                              } else if (_passController.text.isEmpty) {
                                showToastMessage('Please enter your password');
                              } //else if(!numReg.hasMatch(_passController.text)){
                              //showToastMessage('كلمة المرور يجب أن تحتوي على أرقام');
                              //}//else if(!letterReg.hasMatch(_passController.text)){
                              //showToastMessage('كلمة المرور يجب أن تحتوي على حروف');
                              //}
                              else if (_passController.text.length < 6) {
                                showToastMessage(
                                    'Password should be no less than 6 numbers');
                              } else if (_passController.text !=
                                  _repassController.text) {
                                showToastMessage(
                                    'Please reenter your password correctly');
                              } else {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password: _passController.text.trim())
                                    .then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()));
                                }).onError((error, stackTrace) {
                                  showToastMessage("Error ${error.toString()}");
                                });
                              }
                              addUserDetails(_nameController.text.trim(),
                                  _emailController.text.trim());
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          //child: Text('Don\'t have an account? Create'),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(text: "have an account? "),
                            TextSpan(
                              text: 'Sign in',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor),
                            ),
                          ])),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
