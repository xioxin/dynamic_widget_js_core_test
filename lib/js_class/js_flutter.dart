import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:jsrun/js_widget/js_widget.dart';

import '../js_core_page_controller.dart';
import '../tools.dart';

class JsFlutter {
  final JSContext context;
  final BuildContext buildContext;
  JsFlutter(this.context, this.buildContext) {
    var flutterJSClass = JSClass.create(JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'flutter',
      staticFunctions: [
        JSStaticFunction(
          name: 'showWidget',
          callAsFunction: Pointer.fromFunction(showWidget),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
      ],
    ));
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('flutter', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }

  static Pointer showWidget(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
      print('showWidget');
      if (argumentCount > 0) {
        final context = JSContext(ctx);
        final jsVal = JSValue(context, arguments[0]);
        print('保护');
        jsVal.protect();
        jsVal.protect();
        jsVal.protect();
        jsVal.protect();
        jsVal.protect();
        final widget = JsWidget.getWidgetForJSValue(jsVal);
        print(widget);
        final controllerId = context.globalObject.getProperty(PropertyName.controllerId).toNumber().floor();
        final controller = JsCorePageController.getControllerById(controllerId);
        Navigator.push(controller.buildContext, MaterialPageRoute(builder: (_) {
          return widget;
        })).then((val) {
          print('解除保护');
          jsVal.unProtect();
        });
      }
  }



  static Pointer test(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    print('showWidget');
    if (argumentCount > 0) {
      final context = JSContext(ctx);


      final list = jsValueToList(JSValue(context, arguments[0]));
      print("flutter.test");
      print(list.map((e) => e.toObject().getProperty('data').string));

//      final obj = JSValue(context, arguments[0]).toObject();
//      print("a: ${obj.getProperty('a').createJSONString(JSValuePointer(nullptr)).string}");
//      print("b: ${obj.getProperty('b').createJSONString(JSValuePointer(nullptr)).string}");
    }
  }
}



