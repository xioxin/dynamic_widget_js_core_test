import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import '../tools.dart';
import 'js_widget.dart';


class JsRaisedButton extends JsWidget {

  static final String className = 'RaisedButton';
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
        if(onPressedJsValue.isObject) {
          final onPressedObj = onPressedJsValue.toObject();
          if(onPressedObj.isFunction) {
//            that.setProperty('onPressed', onPressedJsValue, JSPropertyAttributes.kJSPropertyAttributeDontDelete);

            onPressedJsValue.protect();
            onPressed = () {
              print(onPressedJsValue);
              print('onPressed');
              final onPressedObj = onPressedJsValue.toObject();
              print(onPressedObj);

//              final context = JSContext(ctx);
//              print('onPressed2');
//              final obj = JSObject(context, onPressedPointer);
//              print(obj.isFunction ? 'is fun': 'not fun');
//              print(obj.isConstructor ? 'is con': 'not con');
//              print('onPressed3');
//              obj.callAsFunction(that,JSValuePointer.array([JSValue.makeString(context, 'test')]));
//              print('onPressed4');
            };
          }
        }
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

    return that.pointer;
  }

  @override
  static injectionJsClass(JSContext context) {
    var flutterJSObject = JSObject.make(context, jsClass);
    context.globalObject.setProperty(className, flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }
}