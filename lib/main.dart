import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:jsrun/tools.dart';
import 'js_class/console.dart';
import 'js_core_page_controller.dart';
import 'js_widget/js_widget.dart';

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
      home: TestBug2(),
    );
  }
}

class TestBug extends StatelessWidget {
  static JSClassDefinition classDef = JSClassDefinition(
    version: 0,
    attributes: JSClassAttributes.kJSClassAttributeNone,
    className: 'Text',
    initialize: Pointer.fromFunction(jsClassInitialize),
    callAsConstructor: Pointer.fromFunction(jsClassConstructor),
    staticFunctions: [],
  );
  static JSClass jsClass = JSClass.create(classDef);

  static Pointer jsClassConstructor(
      Pointer ctx,
      Pointer constructor,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    String text;
    final context = JSContext(ctx);
    final that = JSObject.make(context, jsClass);
    if (argumentCount >= 1) {
      final arg1 = JSValue(context, arguments[0]);
      if (arg1.isString) {
        text = arg1.string;
      }
    }
    that.setProperty('text', JSValue.makeString(context, text),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
    return that.pointer;
  }

  static void jsClassInitialize(Pointer ctx, Pointer object) {
    print('jsClassInitialize');
//    final context = JSContext(ctx);
//    final obj = JSObject(context, object);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: RaisedButton(
        child: Text('TEST'),
        onPressed: () {
          final jsContext = JSContext.createInGroup();
          var flutterJSObject = JSObject.make(jsContext, jsClass);
          jsContext.globalObject.setProperty('Text', flutterJSObject.toValue(),
              JSPropertyAttributes.kJSPropertyAttributeDontDelete);
          final data = jsContext.evaluate("""
              [new Text('测试1'), new Text('测试2'), new Text('测试3')]
            """);
          final list = jsValueToList(data)
              .map((e) => e.toObject().getProperty('text').string);
          print(list);
        },
      )),
    );
  }
}

class TestBug2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: RaisedButton(
        child: Text('TEST2'),
        onPressed: () {
          final jsContext = JSContext.createInGroup();
          jsContext.globalObject.setProperty(
              'test',
              JSObject.makeFunctionWithCallback(
                  jsContext, 'test',
                  Pointer.fromFunction(testFunction)
              ).toValue(),
              JSPropertyAttributes.kJSPropertyAttributeDontDelete);
          JsConsole(jsContext);
          jsContext.evaluate('test((n) => n + n).then((v) => console.log(v))');
        },
      )),
    );
  }

  static Pointer testFunction(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    final context = JSContext(ctx);
//    context.retain();
//    final thisVal = JSValue(context, thisObject);
    final jsv = JSValue(context, arguments[0]);
//    jsv.protect();
//    thisVal.protect();
//    final data = jsv.toObject().callAsFunction(JSObject(context, thisObject), JSValuePointer(JSValue.makeNumber(context, 2.0).pointer));
//    print(data.toNumber());
    print('pointer1:');
    final resolve = JSObject.makeFunction(context, 'resolve', JSStringPointer.array(['value']), '', '');
    print('pointer1-1');
    final reject = JSObject.makeFunction(context, 'reject', JSStringPointer.array(['value']), '', '');
    print('pointer1-2');
    final promise = JSObject.makeDeferredPromise(context, JSObjectPointer(resolve.pointer), JSObjectPointer(reject.pointer));
    print('pointer1-3');

    Future.delayed(const Duration(milliseconds: 300), () {
      print('pointer2:');
      reject.callAsFunction(context.globalObject, JSValuePointer(JSValue.makeNumber(context, 99.0).pointer));
    });

    return promise.pointer;
  }
}

class HomePage extends StatelessWidget {
  JsCorePageController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: RaisedButton(
        child: Text('RUN'),
        onPressed: () {
          if (controller != null) {
            controller.context.release();
            controller = null;
          }

          controller = JsCorePageController(context);
          controller.evaluate('''
console.log('CONTROLLER: ' + __CONTROLLER_ID__);
var test = new Scaffold({
  appBar: new AppBar({title: new Text('标题111'), actions: [
    new RaisedButton({
      child: new Text('Action2'),
      onPressed: () => {
        console.log("button Action");
      }
    }),
  ]}),
  body: new RaisedButton({
    child: new Text('测试222'),
    onPressed: () => {
      console.log("button click");
    }
  })
});
console.log('hello world');
console.log(JSON.stringify(test, null, 2));
flutter.showWidget(test);
''');

//          controller.evaluate("""
//          flutter.test([new Text('测试1'), new Text('测试2'), new Text('测试3')])
//          """);
//          print(JsWidget.widgets);
        },
      )),
    );
  }
}
