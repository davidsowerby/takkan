import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customDisplayType.g.dart';

class CustomDisplayType extends EnumClass {
  static const CustomDisplayType aa = _$aa;
  static const CustomDisplayType ab = _$ab;
  static const CustomDisplayType ac = _$ac;
  static const CustomDisplayType ad = _$ad;

  const CustomDisplayType._(String name) : super(name);

  static BuiltSet<CustomDisplayType> get values => _$values;

  static CustomDisplayType valueOf(String name) => _$valueOf(name);

  static Serializer<CustomDisplayType> get serializer =>
      _$customDisplayTypeSerializer;
}
