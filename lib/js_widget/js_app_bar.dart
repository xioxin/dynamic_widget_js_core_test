import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'js_widget.dart';


class JsAppBar extends JsWidget {
  @override
  static injectionJsClass(JSContext context) {
    final classDef = JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'AppBar',
      callAsConstructor: Pointer.fromFunction(jsClassInitialize),
      finalize: Pointer.fromFunction(jsClassFinalize),
      staticFunctions: [],
    );
    var flutterJSClass = JSClass.create(classDef);
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('AppBar', flutterJSObject.toValue(),
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
    Widget title;
    Widget leading;
    List<Widget> actions;

    if (argumentCount >= 1) {
      final arg1 = JSValue(context, arguments[0]).toObject();
      if (arg1.hasProperty('title')) {
        final value = arg1.getProperty('title');
        that.setProperty('title', value, JSPropertyAttributes.kJSPropertyAttributeDontDelete);
        title = JsWidget.getWidgetForJSValue(value);
      }
      if (arg1.hasProperty('leading')) {
        final value = arg1.getProperty('leading');
        that.setProperty('leading', value, JSPropertyAttributes.kJSPropertyAttributeDontDelete);
        leading = JsWidget.getWidgetForJSValue(value);
      }
      if (arg1.hasProperty('actions')) {
        final actionsObj = arg1.getProperty('actions').toObject();
        final length = actionsObj.getProperty('length').toNumber().toInt();

        that.setProperty('actions', arg1.getProperty('actions'), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
        print('length: $length');
        if(length > 0) {
          actions = [];
          for(int i = 0; i < length; i++) {
            actions.add(JsWidget.getWidgetForJSValue(actionsObj.getPropertyAtIndex(i)));
          }
        }
      }
    }
    final widget = AppBar(
      title: title,
      leading: leading,
      actions: actions,
    );
    final jsWidget = JsAppBar();
    jsWidget.registerWidget('AppBar', widget);
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