import 'dart:async';
import 'dart:ffi';

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
        child: Text('RUN'),
        onPressed: () {
          final controller = JsCorePageController(context);
//          controller.evaluate('''
//console.log('CONTROLLER: ' + __CONTROLLER_ID__);
//var test = new Scaffold({
//  appBar: new AppBar({title: new Text('标题111'), actions: [
//    new RaisedButton({
//      child: new Text('Action2'),
//      onPressed: () => {
//        console.log("button Action");
//      }
//    }),
//  ]}),
//  body: new RaisedButton({
//    child: new Text('测试222'),
//    onPressed: () => {
//      console.log("button click");
//    }
//  })
//});
//console.log('hello world');
//console.log(JSON.stringify(test, null, 2));
//flutter.showWidget(test);
//''');

          controller.evaluate("""
          flutter.test({a: new Text('测试222'), b: new Text('测试222')})
          """);

          print(JsWidget.widgets);

        },
      )),
    );
  }
}
