import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'displayType.g.dart';

class DisplayType extends EnumClass {
  static const DisplayType a = _$a;
  static const DisplayType b = _$b;
  static const DisplayType c = _$c;
  static const DisplayType d = _$d;

  const DisplayType._(String name) : super(name);

  static BuiltSet<DisplayType> get values => _$values;

  static DisplayType valueOf(String name) => _$valueOf(name);

  static Serializer<DisplayType> get serializer => _$displayTypeSerializer;
}
