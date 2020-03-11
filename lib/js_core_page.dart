import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:jsrun/tools.dart';

import 'js_core_helper/function/console.dart';
import 'js_core_helper/function/js_flutter.dart';

class PropertyName {
  static const String controllerId = '__CONTROLLER_ID__';
  static const String widgetKey = '__WIDGET_KEY__';
}

class JsCorePageController {
  JSContext context;
  BuildContext buildContext;

  static Map<int, JsCorePageController> controllers = {};
  static int _controllerTally = 0;
  int controllerId;

  static JsCorePageController getControllerById(int id) => controllers[id];

  JsCorePageController(this.buildContext) {
    controllerId = ++_controllerTally;
    controllers[controllerId] = this;
    context = JSContext.createInGroup();
    context.globalObject.setProperty(
        PropertyName.controllerId,
        JSValue.makeNumber(context, controllerId.toDouble()),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);

    JsConsole(context);
    JsFlutter(context, buildContext);
    JsScaffold.injectionJsClass(context);
    JsText.injectionJsClass(context);
    JsRaisedButton.injectionJsClass(context);

  }

  JSValue evaluate(String script) {
    final value = context.evaluate(script, sourceURL: '<anonymous>');
    if (context.exception.count > 0) {
      final errVal = context.exception.getValue(context, 0);
      if (errVal.isObject) {
        final errObj = errVal.toObject();
        print(errObj.getProperty('name').string +
            ': ' +
            errObj.getProperty('message').string);
        print(errObj.getProperty('stack').string);
        context.exception = JSValuePointer();
      } else {
        print('valueType: ${errVal.type.toString()}');
      }
    }
    return value;
  }
}

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
  static JsWidget getWidgetForJSValue(JSValue jsValue) {
    if(jsValue.isObject) {
      final jsObj = jsValue.toObject();
      if(jsObj.hasProperty(PropertyName.widgetKey)) {
        final widgetKey = jsObj.getProperty(PropertyName.widgetKey).string;
        return getWidgetForKey(widgetKey);
      }
    }
    // todo: 错误处理
  }

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

  static injectionJsClass(JSContext context) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

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
    final jsWidget = JsText();
    jsWidget.registerWidget('Text', widget);
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

class JsScaffold extends JsWidget {
  @override
  static injectionJsClass(JSContext context) {
    final classDef = JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'Scaffold',
      callAsConstructor: Pointer.fromFunction(jsClassInitialize),
      finalize: Pointer.fromFunction(jsClassFinalize),
      staticFunctions: [],
    );
    var flutterJSClass = JSClass.create(classDef);
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('Scaffold', flutterJSObject.toValue(),
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

    Widget appBar;
    Widget body;

    if (argumentCount >= 1) {
      final arg1 = JSValue(context, arguments[0]).toObject();
      if(arg1.hasProperty('appBar')) {
        appBar = JsWidget.getWidgetForJSValue(arg1.getProperty('appBar'));
      }
      if(arg1.hasProperty('body')) {
        body = JsWidget.getWidgetForJSValue(arg1.getProperty('body'));
      }
    }
    final widget = Scaffold(
      body: body,
//      appBar: appBar, todo: Type PreferredSizeWidget
    );
    final jsWidget = JsScaffold();
    jsWidget.registerWidget('Scaffold', widget);
    print( jsWidget.widgetKey);
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



//   RaisedButton(onPressed: () {}, child: ,)
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
      if(arg1.hasProperty('child')) {
        child = JsWidget.getWidgetForJSValue(arg1.getProperty('child'));
      }
      if(arg1.hasProperty('onPressed')) {
        print('onPressed 0');
        final onPressedJsValue = arg1.getProperty('onPressed');
        print(jsValueType(onPressedJsValue));

        print('onPressed 1');
        final onPressedObj = onPressedJsValue.toObject();
        print('onPressed 2');
        onPressed = () {
          print('onPressed 3');
//          onPressedObj.isFunction
          onPressedObj.callAsFunction(JSValue.makeNull(context).toObject(), JSValuePointer.array([]));
        };
      }
    }
    final widget = RaisedButton(
      child: child,
      onPressed: onPressed,
    );
    final jsWidget = JsRaisedButton();
    jsWidget.registerWidget('RaisedButton', widget);
    print( jsWidget.widgetKey);
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
