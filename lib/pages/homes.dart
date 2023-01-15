import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';

import '../common/theme_helper.dart';
import 'registration_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  TextEditingController nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      nameController.text = snapshot.get("firstName");
      // image = snapshot.get('image');
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
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white,
        // backgroundColor: Colors.red,
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

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "iRecycle",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ])),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(
              children: <Widget>[
                // Icon(Icons.notifications),
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor,
                  ],
                ),
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Irecycle",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home_filled,
                size: _drawerIconSize,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Home Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).accentColor),
              ),
              onTap: () {
                /*   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  ); */
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).accentColor),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginPage();
                    },
                  ),
                );
                //do
                showToastMessage("logout successfully");
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                size: _drawerIconSize,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Delete account',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).accentColor),
              ),
              onTap: () {
                _showDialog();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 130, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.email.toString(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'login successfully',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.white,
            iconSize: 30,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Theme.of(context).primaryColorLight,
            color: Colors.white,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.park_sharp,
                text: 'community',
              ),
              GButton(
                icon: Icons.document_scanner_outlined,
                text: 'classifier',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
