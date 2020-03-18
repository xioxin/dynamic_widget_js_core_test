import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';

class PropertyName {
  static const String controllerId = '__CONTROLLER_ID__';
  static const String widgetKey = '__WIDGET_KEY__';
}

class JsWidget {
  static Map<String, dynamic> staticFunction = {};
  static int _widgetId = 0;
  static Map<String, JsWidget> widgets = {};

  static newWidgetId() {
    return _widgetId++;
  }

  static Widget getWidgetForKey(String key) => widgets[key]?.widget;

  static Widget getWidgetForJSValue(JSValue jsValue) {
    if (jsValue.isObject) {
      final jsObj = jsValue.toObject();
      if (jsObj.hasProperty(PropertyName.widgetKey)) {
        final widgetKey = jsObj.getProperty(PropertyName.widgetKey).string;
        return getWidgetForKey(widgetKey);
      }
    }
    return null;
    // todo: 错误处理
  }

  Widget widget;

  registerWidget(String widgetName, Widget widget) {
    widgetKey = '$widgetName:${newWidgetId()}';
    print('registerWidget: $widgetKey $widget');
    this.widget = widget;
    widgets[widgetKey] = this;
    return widgetKey;
  }

  String widgetName;
  String widgetKey;
  JSContext context;

  static final String className = '';
  @override
  static final JSClassDefinition classDef = JSClassDefinition(
    version: 0,
    attributes: JSClassAttributes.kJSClassAttributeNone,
    className: className,
    initialize: Pointer.fromFunction(jsClassInitialize),
    callAsConstructor: Pointer.fromFunction(jsClassConstructor),
    finalize: Pointer.fromFunction(jsClassFinalize),
    staticFunctions: staticFunctions,
  );
  @override
  static final List<JSStaticFunction> staticFunctions = [];
  @override
  static final jsClass = JSClass.create(classDef);
  @override
  static void jsClassInitialize(Pointer ctx, Pointer object) {
//    print('jsClassInitialize');
  }
  @override
  static void jsClassFinalize(Pointer object) {
//    print("jsClassFinalize 即将销毁");
  }
  @override
  static Pointer jsClassConstructor(
      Pointer ctx,
      Pointer constructor,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    return constructor;
  }

  @override
  static injectionJsClass(JSContext context) {
    assert(className == null);
    var flutterJSObject = JSObject.make(context, jsClass);
    context.globalObject.setProperty(className, flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }
}
