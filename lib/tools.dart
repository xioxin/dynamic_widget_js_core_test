import 'package:flutter_jscore/flutter_jscore.dart';

String jsValueType(JSValue value) {
  if(value.isArray) return 'Array';
  if(value.isBoolean) return 'Boolean';
  if(value.isDate) return 'Date';
  if(value.isNull) return 'Null';
  if(value.isNumber) return 'Number';
  if(value.isString) return 'String';
  if(value.isSymbol) return 'Symbol';
  if(value.isUndefined) return 'Undefined';
  if(value.isObject) {
    final obj = value.toObject();
    if(obj.isFunction) return 'Object: Function';
    if(obj.isConstructor) return 'Object: Constructor';
    return 'Object';
  }
}


List<JSValue> jsValueToList(JSValue value) {
  final obj = value.toObject();
  final List<JSValue> list = [];
  final length = obj.getProperty('length').toNumber().toInt();
  if(length > 0) {
    for(int i = 0; i < length; i++) {
      list.add(obj.getPropertyAtIndex(i));
    }
  }
  return list;
}