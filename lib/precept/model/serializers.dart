library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:precept/precept/model/displayType.dart';
import 'package:precept/precept/model/precept-signin.dart';
import 'package:precept/precept/model/precept.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  PreceptSignIn,
  Backend,
  DisplayType,
  Precept,
  PreceptComponent,
  PreceptRoute,
  PreceptPage,
  PreceptSectionLookup,
  PreceptSection,
  PreceptField,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
