import 'package:flutter/material.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/type_selection_screen.dart';
//todo add keys to widget constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.light(),
      color: primaryColor,
      home: Material(child: SafeArea(child: TypeSelectionScreen())),
    );
  }
}
