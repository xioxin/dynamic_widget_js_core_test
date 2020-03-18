import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'js_widget.dart';


class JsText extends JsWidget {

  static final String className = 'Text';
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
    String text;
    final context = JSContext(ctx);
    final jsWidget = JsText();
    final that = JSObject.make(context, jsClass);
    if (argumentCount >= 1) {
      final arg1 = JSValue(context, arguments[0]);
      if (arg1.isString) {
        text = arg1.string;
      }
    }
    if (argumentCount >= 2) {
      // 额外参数
    }
    final widget = Text(text ?? '');
    jsWidget.registerWidget('Text', widget);
    that.setProperty(
        PropertyName.widgetKey,
        JSValue.makeString(context, jsWidget.widgetKey),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);

    that.setProperty(
        'data',
        JSValue.makeString(context, text),
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
