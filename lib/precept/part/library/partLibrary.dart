import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'partLibrary.g.dart';

class CorePart extends EnumClass {
  static const CorePart address = _$address;
  static const CorePart contact = _$contact;

  const CorePart._(String name) : super(name);

  static BuiltSet<CorePart> get values => _$values;

  static CorePart valueOf(String name) => _$valueOf(name);

  static Serializer<CorePart> get serializer => _$corePartSerializer;
}

class PartLibrary {}
