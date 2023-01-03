import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/authentication.dart';
import 'package:orora2/homepage.dart';
import 'package:orora2/json/user.dart';
import 'package:orora2/super_base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const primaryColor = Color(0xff9BCA20);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORORA',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1.0,
          titleTextStyle: TextStyle(color: Colors.black87),
          iconTheme: IconThemeData(color: Colors.black87)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
              padding: MaterialStateProperty.all(const EdgeInsets.all(14)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            )),
            elevation: MaterialStateProperty.all(0),
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(vertical: 14,horizontal: 17),
          fillColor: const Color(0xffF2F1F7),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(14),
            textStyle: const TextStyle(color: primaryColor),
              foregroundColor: primaryColor,
            side: const BorderSide(color: primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            )
          )
        )
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends Superbase<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async  {
      var string = (await prefs).getString(userKey);
      if(string != null){
        if(mounted) {
          User.user = User.fromJson(jsonDecode(string));
          Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => const Homepage()));
        }
      }else if(mounted){
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const Authentication()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/logo.png"))
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
