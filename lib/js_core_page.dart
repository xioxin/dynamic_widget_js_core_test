import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:jsrun/tools.dart';

import 'js_core_helper/function/console.dart';

class JsCorePageController {
  JSContext context;

  JsCorePageController () {
    context = JSContext.createInGroup();
    JsConsole(context);
    JsListView.jsClass(context);
  }

  JSValue evaluate(String script) {
    final value = context.evaluate(script, sourceURL: '<anonymous>');
    if(context.exception.count > 0 ) {
      final errVal = context.exception.getValue(context, 0);
      if(errVal.isObject) {
        final errObj = errVal.toObject();
        print(errObj.getProperty('name').string +': '+errObj.getProperty('message').string);
        print(errObj.getProperty('stack').string);
        context.exception = JSValuePointer();
      } else {
        print('valueType: ${errVal.type.toString()}');
      }
    }
    return value;
  }
}


//
//
//class JsCorePage {
//
//
//  String script;
//  final JsCorePageController controller;
//
//  JsCorePage ({
//    this.script = '',
//    this.controller,
//  })
//
//
//}
//



class JsCorePage extends StatefulWidget {

  String script;
  JsCorePageController controller;

  JsCorePage({Key key, this.script, this.controller}) : super(key: key) {
    this.controller ??= JsCorePageController();
    controller.evaluate(this.script);
  }

  @override
  _JsCorePageState createState() => _JsCorePageState();
}

class _JsCorePageState extends State<JsCorePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class JsListView extends StatelessWidget {


  static jsClass(JSContext context) {
    final classDef = JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'ListView',
      callAsConstructor: Pointer.fromFunction(jsClassInitialize),
      finalize: Pointer.fromFunction(jsClassFinalize),
      staticFunctions: [
      ],
    );
    var flutterJSClass = JSClass.create(classDef);
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('ListView', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }

  static Pointer jsClassInitialize(
      Pointer ctx,
      Pointer constructor,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    print('jsClassInitialize 1');
    final context = JSContext(ctx);
    print('jsClassInitialize 2');
    final that = JSValue(context, constructor).toObject();
    var function = JSObject.makeFunctionWithCallback(context, 'test', Pointer.fromFunction(test));
    that.setProperty('test', function.toValue(), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
    that.setProperty('val1', JSValue.makeString(context, 'test'), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
    return constructor;
   }

  static void jsClassFinalize(Pointer object) {
    print("jsClassFinalize 即将销毁");
  }

  static Pointer test(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    print("jsClassInitialize test");
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
