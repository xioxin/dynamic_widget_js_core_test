



import 'package:flutter_jscore/flutter_jscore.dart';

String jsValueType(JSValue value) {
  if(value.isArray) return 'Array';
  if(value.isBoolean) return 'Boolean';
  if(value.isDate) return 'Date';
  if(value.isNull) return 'Null';
  if(value.isNumber) return 'Number';
  if(value.isObject) {
    final obj = value.toObject();
    if(obj.isFunction) return 'Object: Function';
    if(obj.isConstructor) return 'Object: Constructor';
    return 'Object';
  }
  if(value.isString) return 'String';
  if(value.isSymbol) return 'Symbol';
  if(value.isUndefined) return 'Undefined';

}
