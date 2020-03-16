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
        print('getWidgetForKey widgetKey: $widgetKey');

        return getWidgetForKey(widgetKey);
      }
    }
    print('getWFJSV???');

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

  static injectionJsClass(JSContext context) {}
}
