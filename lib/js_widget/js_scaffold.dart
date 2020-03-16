import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'js_widget.dart';

class JsScaffold extends JsWidget {
  @override
  static injectionJsClass(JSContext context) {
    final classDef = JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'Scaffold',
      callAsConstructor: Pointer.fromFunction(jsClassInitialize),
      finalize: Pointer.fromFunction(jsClassFinalize),
      staticFunctions: [],
    );
    var flutterJSClass = JSClass.create(classDef);
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('Scaffold', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }

  static Pointer jsClassInitialize(
      Pointer ctx,
      Pointer constructor,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    final context = JSContext(ctx);
    final that = JSValue(context, constructor).toObject();

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
    return constructor;
  }

  static void jsClassFinalize(Pointer object) {
    print("jsClassFinalize 即将销毁");
  }

}
