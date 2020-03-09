import 'dart:ffi';

import 'package:flutter_jscore/flutter_jscore.dart';

class JsFetch {
  JSContext context;
  JsFetch(this.context, {String name = 'fetch'}) {
    _fetchDartFunc = _fetch;
    var fetchJsFunction = JSObject.makeFunctionWithCallback(
        context, name, Pointer.fromFunction(fetch));
    context.globalObject.setProperty(name, fetchJsFunction.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeNone);
  }

  static JSObjectCallAsFunctionCallbackDart _fetchDartFunc;
  static Pointer fetch(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (_fetchDartFunc != null) {
      _fetchDartFunc(
          ctx, function, thisObject, argumentCount, arguments, exception);
    }
  }

  void _fetch(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (argumentCount != 0) {

//      JSObject.makeDeferredPromise(context, )


    }
  }
}



