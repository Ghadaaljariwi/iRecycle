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
import '../Mycard.dart';
import 'bloc/category_bloc.dart';
import 'cat.dart';
import 'category.dart';
import 'categoryDetail.dart';

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
  List<category> list = [];
  final _controller = PageController();

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

  void please() {
    FirebaseFirestore.instance
        .collection("categories")
        .doc()
        .snapshots()
        .listen((snapshot) {
      String name = snapshot.get('name');
      String des = snapshot.get('description');
      String img = snapshot.get('image');
      showToastMessage(name + des + img);
    });
/*
                      if (snapshot.data!.docs.isEmpty) {
                        showToastMessage('empty');
                        print('empty');
                        // return const LinearProgressIndicator();
                      }
                      for (var obj in snapshot.data!.docs) {
                        String name = obj.get('name');
                        String des = obj.get('description');
                        category toadd = category(name: name, description: des);
                        print(name + des);
                        showToastMessage(name + des);
                        list.add(toadd);
                      }
                      */
  }

/*
  Future _getUserDetail() async {
    Map<String, dynamic> snapshot =
        (await FirebaseFirestore.instance.collection('users').get() ) as Map<String, dynamic> ;

    snapshot.docs.forEach((document) {
      category obj = category.fromMap(document.data() as Map<String, dynamic>);
      list.add(obj);
    });
  }
*/

  int index = 0;

  List<Color> myColors = [
    Color.fromARGB(255, 189, 232, 152),
    Color.fromARGB(255, 249, 215, 255),
    Color.fromARGB(255, 255, 221, 176),
    Color.fromARGB(255, 176, 230, 255),
  ];

  Color chooseColor(int i) {
    index++;
    return myColors[i];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Categories",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                /*
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
                */
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "iRecycle",
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
                  'Log Out',
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
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Container(
                    width: width,
                    //height: height,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('categories')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const LinearProgressIndicator();
                          }
                          return Stack(
                            children: [
                              snapshot.hasData
                                  ? ListView(
                                      //scrollDirection: Axis.vertical,
                                      //controller: _controller,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: snapshot.data!.docs
                                          .map((DocumentSnapshot data) {
                                        return InkWell(
                                          child: Cat(
                                            id: data["id"],
                                            name: data['name'],
                                            description: data['description'],
                                            image: data['image'],
                                            color: chooseColor(index % 4),
                                            wid: width,
                                            w: 200,
                                            h: 200,
                                            admin: true,
                                          ),
                                          onTap: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryDetail(cat: data),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : Container(
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.error,
                                            color: Colors.grey[700],
                                            size: 64,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Text(
                                              'There is no category',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[700]),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                              // Utils.loadingCircle(_isLoading),
                            ],
                          );
                        }),
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
            ),
          ],
        ),
      ),
    );
  }
}
