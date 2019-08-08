import 'package:flutter/material.dart';
import 'package:pogo/consts.dart';
import 'package:pogo/progress_button.dart';
//todo add keys to widget constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.light(),
      color: primaryColor,
      home: Material(
        child: SafeArea(
          child: Center(
            child: ProgressButton(
              height: 150,
              width: 150,
              color: Colors.orange,
              duration: Duration(seconds: 3),
              onPressCompleted: () => debugPrint("completed long press!"),
            ),
          ),
        ),
      ),
    );
  }
}
