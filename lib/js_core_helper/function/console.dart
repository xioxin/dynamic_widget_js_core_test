import 'dart:ffi';

import 'package:flutter_jscore/flutter_jscore.dart';

class JsConsole {
  final JSContext context;
  JsConsole(this.context) {
    _consoleLogDartFunc = _consoleLog;
    var flutterJSClass = JSClass.create(JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'console',
      staticFunctions: [
        JSStaticFunction(
          name: 'log',
          callAsFunction: Pointer.fromFunction(consoleLog),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
        JSStaticFunction(
          name: 'info',
          callAsFunction: Pointer.fromFunction(consoleLog),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
        JSStaticFunction(
          name: 'warn',
          callAsFunction: Pointer.fromFunction(consoleLog),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
        JSStaticFunction(
          name: 'error',
          callAsFunction: Pointer.fromFunction(consoleLog),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
      ],
    ));
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('console', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }

  static JSObjectCallAsFunctionCallbackDart _consoleLogDartFunc;
  static Pointer consoleLog(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (_consoleLogDartFunc != null) {
      _consoleLogDartFunc(
          ctx, function, thisObject, argumentCount, arguments, exception);
    }
  }

  Pointer _consoleLog(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (argumentCount != 0) {
      if (argumentCount > 0) {
        print(JSValue(context, arguments[0]).string);
      }
    }
  }
}



