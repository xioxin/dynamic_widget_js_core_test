import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jscore/flutter_jscore.dart';

import 'js_core_helper/function/console.dart';
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
      home: JsCorePage(),
    );
  }
}

class JsCorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JsCorePageState();
  }
}

class JsCorePageState extends State<JsCorePage> {
  TextEditingController _jsInputController;

  String _result;

  JSContext _jsContext;

  @override
  void initState() {
    super.initState();
    _jsContext = JSContext.createInGroup();


    _alertDartFunc = _alert;


    var jsAlertFunction = JSObject.makeFunctionWithCallback(
        _jsContext, 'alert', Pointer.fromFunction(alert));



    _jsContext.globalObject.setProperty('alert', jsAlertFunction.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeNone);

//    _jsContext.globalObject.setProperty('alert', jsAlertFunction.toValue(),
//        JSPropertyAttributes.kJSPropertyAttributeNone);
//
//
//    ;



    JsConsole(_jsContext);


    _printDartFunc = _print;

    _showPageDartFunc = _showPage;


    var flutterJSClass = JSClass.create(JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'flutter',
      staticFunctions: [
        JSStaticFunction(
          name: 'print',
          callAsFunction: Pointer.fromFunction(flutterPrint),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
        JSStaticFunction(
          name: 'showPage',
          callAsFunction: Pointer.fromFunction(showPage),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
      ],
    ));


    var flutterJSObject = JSObject.make(_jsContext, flutterJSClass);
    _jsContext.globalObject.setProperty('flutter', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
    var windowJSClass = JSClass.create(JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'window',
      staticFunctions: [],
    ));
    var windowJSObject = JSObject.make(_jsContext, windowJSClass);
    _jsContext.globalObject.setProperty('window', windowJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);

    // 设置默认JavaScript脚本
    _jsInputController = TextEditingController(text: '''
    console.log(flutter.showPage('123'));
    ''');

//    rootBundle.loadString('assets/example.js').then((value) {
//      _jsInputController.text = value;
//    });
  }

  @override
  void dispose() {
    _jsInputController.dispose();
    // 释放js上下文
    _jsContext.release();
    super.dispose();
  }

  /// 绑定JavaScript alert()函数
  static Pointer alert(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (_alertDartFunc != null) {
      _alertDartFunc(
          ctx, function, thisObject, argumentCount, arguments, exception);
    }
  }

  static JSObjectCallAsFunctionCallbackDart _alertDartFunc;

  Pointer _alert(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    String msg = 'No Message';
    if (argumentCount != 0) {
      msg = '';
      for (int i = 0; i < argumentCount; i++) {
        if (i != 0) {
          msg += '\n';
        }
        var jsValueRef = arguments[i];
        msg += JSValue(_jsContext, jsValueRef).string;
      }
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(msg),
          );
        });
  }

  /// 绑定flutter.print()函数
  static Pointer flutterPrint(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (_printDartFunc != null) {
      _printDartFunc(
          ctx, function, thisObject, argumentCount, arguments, exception);
    }
  }

  static JSObjectCallAsFunctionCallbackDart _showPageDartFunc;
  static Pointer showPage(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (_showPageDartFunc != null) {
      return _showPageDartFunc(
          ctx, function, thisObject, argumentCount, arguments, exception);
    }
  }
  Pointer _showPage(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (argumentCount > 0) {
//      final json = JSValue(_jsContext, arguments[0]).string;
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => PreviewPage(json)));
    }
    return JSValue.makeString(_jsContext, 'test val').pointer;
  }

  static JSObjectCallAsFunctionCallbackDart _printDartFunc;

  Pointer _print(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (argumentCount > 0) {
      print(JSValue(_jsContext, arguments[0]).string);
    }
  }

  String _runJs(String script) {
    try {
      var jsValue = _jsContext.evaluate(script, sourceURL: '<anonymous>');
      print(_jsContext.exception.count);
      if(_jsContext.exception.count > 0 ) {
        final errVal = _jsContext.exception.getValue(_jsContext, 0);
        if(errVal.isObject) {
          final errObj = errVal.toObject();
          print(errObj.getProperty('name').string +': '+errObj.getProperty('message').string);
          print(errObj.getProperty('stack').string);
          _jsContext.exception = JSValuePointer();
        } else {
          print('valueType: ${errVal.type.toString()}');
        }
      }
      return jsValue.string;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JavaScriptCore for Flutter'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 10.0),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text('JavaScript:'),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border:
                  Border.all(width: 1.0, color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.all(new Radius.circular(5.0)),
            ),
            child: TextField(
              controller: _jsInputController,
              maxLines: 30,
              style: TextStyle(
                fontSize: 12.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text('Result: ${_result ?? ''}'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _result = _runJs(_jsInputController.text ?? '');
          });
        },
        child: Icon(Icons.autorenew),
      ),
    );
  }
}
