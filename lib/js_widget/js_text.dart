import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'js_widget.dart';


class JsText extends JsWidget {
  @override
  static injectionJsClass(JSContext context) {
    final classDef = JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'Text',
      callAsConstructor: Pointer.fromFunction(jsClassInitialize),
      finalize: Pointer.fromFunction(jsClassFinalize),
      staticFunctions: [],
    );
    var flutterJSClass = JSClass.create(classDef);
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('Text', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }

  static Pointer jsClassInitialize(
      Pointer ctx,
      Pointer constructor,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    String text;
    final context = JSContext(ctx);
    final jsWidget = JsText();
//    final that = JSObject();
    final that = JSValue(context, constructor).toObject();

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

    return constructor;
  }

  static void jsClassFinalize(Pointer object) {
    print("jsClassFinalize 即将销毁");
  }

}
