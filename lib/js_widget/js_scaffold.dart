import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'js_widget.dart';

class JsScaffold extends JsWidget {

  static final String className = 'Scaffold';
  static final JSClassDefinition classDef = JSClassDefinition(
    version: 0,
    attributes: JSClassAttributes.kJSClassAttributeNone,
    className: className,
    initialize: Pointer.fromFunction(jsClassInitialize),
    callAsConstructor: Pointer.fromFunction(jsClassConstructor),
    finalize: Pointer.fromFunction(jsClassFinalize),
    staticFunctions: [],
  );
  static final List<JSStaticFunction> staticFunctions = [];

  static final jsClass = JSClass.create(classDef);

  static void jsClassInitialize(Pointer ctx, Pointer object) {
    print('jsClassInitialize');
  }
  static void jsClassFinalize(Pointer object) {
    print("jsClassFinalize 即将销毁");
  }

  static Pointer jsClassConstructor(
      Pointer ctx,
      Pointer constructor,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    final context = JSContext(ctx);
    final that = JSObject.make(context, jsClass);

    Widget appBar;
    Widget body;

    if (argumentCount >= 1) {
      final arg1 = JSValue(context, arguments[0]).toObject();
      if (arg1.hasProperty('appBar')) {
        that.setProperty('appBar', arg1.getProperty('appBar'), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
        appBar = JsWidget.getWidgetForJSValue(arg1.getProperty('appBar'));
      }
      if (arg1.hasProperty('body')) {
        that.setProperty('body', arg1.getProperty('body'), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
        body = JsWidget.getWidgetForJSValue(arg1.getProperty('body'));
      }
    }
    final widget = Scaffold(
      appBar: appBar,
      body: body,
    );
    final jsWidget = JsScaffold();
    jsWidget.registerWidget('Scaffold', widget);
    print(jsWidget.widgetKey);
    that.setProperty(
        PropertyName.widgetKey,
        JSValue.makeString(context, jsWidget.widgetKey),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);

    return that.pointer;
  }

  @override
  static injectionJsClass(JSContext context) {
    var flutterJSObject = JSObject.make(context, jsClass);
    context.globalObject.setProperty(className, flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }
}