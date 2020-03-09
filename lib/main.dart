import 'dart:async';
import 'dart:ffi';

import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jscore/flutter_jscore.dart';

import 'js_core_helper/function/console.dart';
import 'js_core_page.dart';
import 'widget_json.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Widget',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: RaisedButton(
        child: Text('打开就是'),
        onPressed: () {


          final controller = JsCorePageController();

          controller.evaluate('''
var listV = new ListView();
listV.test();
console.log(Object.keys(listV).toString());
listV = null;

''');

        },
      )),
    );
  }
}
