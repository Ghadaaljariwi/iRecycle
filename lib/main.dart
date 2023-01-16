import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irecycle/onBording/onbording.dart';
import 'package:irecycle/pages/AdminHome.dart';
import 'package:irecycle/pages/Bloc/home_bloc.dart';
import 'package:irecycle/pages/BlocCategories/addCategory.dart';
import 'package:irecycle/pages/BlocCategories/bloc/category_bloc.dart';
import 'package:irecycle/pages/BlocCategories/category.dart';
import 'package:irecycle/pages/home.dart';
import 'package:irecycle/pages/homes.dart';
import 'package:irecycle/pages/login_page.dart';
import 'package:irecycle/pages/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Map<int, Color> color = {
  50: Color.fromARGB(255, 65, 102, 39),
  100: Color.fromARGB(255, 65, 102, 39),
  200: Color.fromARGB(255, 94, 145, 74),
  300: Color.fromARGB(255, 135, 174, 96),
  400: Color.fromARGB(255, 169, 221, 126),
  500: Color.fromARGB(255, 169, 221, 126),
  600: Color.fromARGB(255, 169, 221, 126),
  700: Color.fromARGB(255, 135, 174, 96),
  800: Color.fromARGB(255, 94, 145, 74),
  900: Color.fromARGB(255, 65, 102, 39),
};

MaterialColor colorCustom = MaterialColor(0xFF8BC34A, color);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(
    providers: [
      //const MyApp());
      BlocProvider(
        create: (context) => HomeBloc(),
      ),

      BlocProvider(
        create: (context) => CategoryBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: AdminHomePage(), //OnboardingScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
