
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';

import 'js_class/console.dart';
import 'js_class/js_flutter.dart';
import 'js_widget/js_app_bar.dart';
import 'js_widget/js_raised_button.dart';
import 'js_widget/js_scaffold.dart';
import 'js_widget/js_text.dart';
import 'js_widget/js_widget.dart';

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
    context.retain();
//    JSManagedValue
    JsConsole(context);
    JsFlutter(context, buildContext);
    JsScaffold.injectionJsClass(context);
    JsText.injectionJsClass(context);
    JsAppBar.injectionJsClass(context);
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
