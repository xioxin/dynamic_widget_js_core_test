import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';

import 'js_core_helper/function/console.dart';
import 'js_core_helper/function/js_flutter.dart';


class PropertyName {
  static const String controllerId = '__CONTROLLER_ID__';
}

class JsCorePageController {
  JSContext context;
  BuildContext buildContext;

  static Map<int, JsCorePageController> controllers = {};
  static int _controllerTally = 0;
  int controllerId;

  static JsCorePageController getControllerById(int id) => controllers[id];

  JsCorePageController (this.buildContext) {
    controllerId = ++_controllerTally;
    controllers[controllerId] = this;
    context = JSContext.createInGroup();
    context.globalObject.setProperty(PropertyName.controllerId, JSValue.makeNumber(context, controllerId.toDouble()),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);

    JsConsole(context);
    JsFlutter(context, buildContext);
    JsText.injectionJsClass(context);
  }

  JSValue evaluate(String script) {
    final value = context.evaluate(script, sourceURL: '<anonymous>');
    if(context.exception.count > 0 ) {
      final errVal = context.exception.getValue(context, 0);
      if(errVal.isObject) {
        final errObj = errVal.toObject();
        print(errObj.getProperty('name').string +': '+errObj.getProperty('message').string);
        print(errObj.getProperty('stack').string);
        context.exception = JSValuePointer();
      } else {
        print('valueType: ${errVal.type.toString()}');
      }
    }
    return value;
  }
}


//
//
//class JsCorePage {
//
//
//  String script;
//  final JsCorePageController controller;
//
//  JsCorePage ({
//    this.script = '',
//    this.controller,
//  })
//
//
//}
//






class JsCorePage extends StatefulWidget {

  String script;

  JsCorePage({Key key, this.script}) : super(key: key);
  @override
  _JsCorePageState createState() => _JsCorePageState();
}

class _JsCorePageState extends State<JsCorePage> {
  JsCorePageController controller;

  @override
  void initState() {
    this.controller ??= JsCorePageController(this.context);
    controller.evaluate(widget.script);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class JsWidget extends StatelessWidget {
  static Map<String, dynamic> staticFunction = {};
  static int _widgetId = 0;
  static Map<String, JsWidget> widgets = {};
  static newWidgetId() {
    return ++_widgetId;
  }

  static JsWidget getWidgetForKey(String key) => widgets[key];

  Widget widget;
  registerWidget(String widgetName, Widget widget) {
    widgetKey = '$widgetName:${newWidgetId()}';
    this.widget = widget;
    widgets[widgetKey] = this;
    return widgetKey;
  }
  String widgetName;
  String widgetKey;
  JSContext context;

  static injectionJsClass(JSContext context) {

  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

}



class JsText extends JsWidget {

  @override
  static injectionJsClass(JSContext context) {
    final classDef = JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'ListView',
      callAsConstructor: Pointer.fromFunction(jsClassInitialize),
      finalize: Pointer.fromFunction(jsClassFinalize),
      staticFunctions: [

      ],
    );
    var flutterJSClass = JSClass.create(classDef);
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('ListView', flutterJSObject.toValue(),
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
    final arg = JSValue(context, arguments).toObject().getPropertyAtIndex(0).toObject();
    var function = JSObject.makeFunctionWithCallback(context, 'test', Pointer.fromFunction(test));
    that.setProperty('test', function.toValue(), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
    final widget = Text(arg.getProperty('data').string ?? '');
    final jsWidget = JsText();
    jsWidget.registerWidget('Text', widget);
    that.setProperty('widgetKey', JSValue.makeString(context, jsWidget.widgetKey), JSPropertyAttributes.kJSPropertyAttributeDontDelete);
    return constructor;
   }

  static void jsClassFinalize(Pointer object) {
    print("jsClassFinalize 即将销毁");
  }

  static Pointer test(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    print("jsClassInitialize test");
  }

  @override
  Widget build(BuildContext context) {
    return this.widget;
  }
}








