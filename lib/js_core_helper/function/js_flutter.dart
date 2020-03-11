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
    context.globalObject.setProperty('console', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }

  static Pointer showWidget(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (argumentCount > 0) {
      final context = JSContext(ctx);

      final widgetKey = JSValue(context, arguments[0]).toObject().getProperty('widgetKey').string;
      final widget = JsWidget.getWidgetForKey(widgetKey);
      final controllerId = context.globalObject.getProperty(PropertyName.controllerId).toNumber().floor();
      final controller = JsCorePageController.getControllerById(controllerId);

      Navigator.of(controller.buildContext).push(MaterialPageRoute(builder: (BuildContext context) {
        return widget;
      }));
    }
  }
}



