import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import '../tools.dart';
import 'js_widget.dart';

class JsRaisedButton extends JsWidget {
  @override
  static injectionJsClass(JSContext context) {
    final classDef = JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'RaisedButton',
      callAsConstructor: Pointer.fromFunction(jsClassInitialize),
      finalize: Pointer.fromFunction(jsClassFinalize),
      staticFunctions: [],
    );
    var flutterJSClass = JSClass.create(classDef);
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('RaisedButton', flutterJSObject.toValue(),
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

    Widget child;
    VoidCallback onPressed;

    if (argumentCount >= 1) {
      final arg1 = JSValue(context, arguments[0]).toObject();
      if (arg1.hasProperty('child')) {
        that.setProperty('child', arg1.getProperty('child'), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
        child = JsWidget.getWidgetForJSValue(arg1.getProperty('child'));
      }
      if (arg1.hasProperty('onPressed')) {
        that.setProperty('onPressed', arg1.getProperty('onPressed'), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
        final onPressedJsValue = arg1.getProperty('onPressed');
        print(jsValueType(onPressedJsValue));

        final onPressedObj = onPressedJsValue.toObject();
        onPressed = () {
          print('onPressed');
          onPressedObj.callAsFunction(context.globalObject,
              JSValuePointer.array([JSValue.makeString(context, 'test')]));
        };
      }
    }
    final widget = RaisedButton(
      child: child,
      onPressed: onPressed,
    );
    final jsWidget = JsRaisedButton();
    jsWidget.registerWidget('RaisedButton', widget);
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

  @override
  Widget build(BuildContext context) {
    return this.widget;
  }
}
