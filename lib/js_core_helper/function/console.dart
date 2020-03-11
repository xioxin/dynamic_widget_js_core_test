import 'dart:ffi';

import 'package:flutter_jscore/flutter_jscore.dart';

class JsConsole {
  final JSContext context;
  JsConsole(this.context) {
    var flutterJSClass = JSClass.create(JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'console',
      staticFunctions: [
        JSStaticFunction(
          name: 'log',
          callAsFunction: Pointer.fromFunction(_consoleLog),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
        JSStaticFunction(
          name: 'info',
          callAsFunction: Pointer.fromFunction(_consoleLog),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
        JSStaticFunction(
          name: 'warn',
          callAsFunction: Pointer.fromFunction(_consoleLog),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
        JSStaticFunction(
          name: 'error',
          callAsFunction: Pointer.fromFunction(_consoleLog),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
      ],
    ));
    var flutterJSObject = JSObject.make(context, flutterJSClass);
    context.globalObject.setProperty('console', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
  }

  static Pointer _consoleLog(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (argumentCount > 0) {
      print(JSValue(JSContext(ctx), arguments[0]).string);
    }
  }
}



