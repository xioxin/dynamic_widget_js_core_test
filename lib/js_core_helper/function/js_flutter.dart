import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:jsrun/js_core_page.dart';

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
        final widget = JsWidget.getWidgetForJSValue(JSValue(context, arguments[0]));
        print(widget);
        final controllerId = context.globalObject.getProperty(PropertyName.controllerId).toNumber().floor();
        final controller = JsCorePageController.getControllerById(controllerId);
        Navigator.push(controller.buildContext, MaterialPageRoute(builder: (_) {
          return widget;
        }));
      }
  }
}



