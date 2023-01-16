import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irecycle/pages/BlocCategories/category.dart';
import 'package:irecycle/pages/BlocCategories/categoryField.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:irecycle/pages/widgets/header_widget.dart';

import '../../common/theme_helper.dart';
import 'bloc/category_bloc.dart';
import 'category.dart';

class addCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _addCategoryState();
  }
}

class _addCategoryState extends State<addCategory> {
  //final user = FirebaseAuth.instance.currentUser!;
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  TextEditingController nameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        List<category> list = state.categoryList;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                "Categories",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
                    Theme.of(context).colorScheme.secondary,
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
            child: Container(
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
                          Theme.of(context).colorScheme.secondary,
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
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(
                      'Home Page',
                      style: TextStyle(
                          fontSize: _drawerFontSize,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    onTap: () {
                      Navigator.pop(context);
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
                      // _showDialog();
                    },
                  ),
                ],
              ),
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
                      Container(
                        width: 100,
                        height: 100,
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            IconData iconData;
                            Color iconColor;
                            return Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 5,
                              ),
                              child: new ListTile(
                                title: Text(
                                  list[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                subtitle: Text(
                                  list[index].description,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          },
                          itemCount: list.length,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                          onPressed: (() => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return CategoryField();
                              }))),
                          child: const Icon(Icons.add)),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
