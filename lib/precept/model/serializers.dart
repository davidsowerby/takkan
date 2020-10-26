library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:precept/precept/model/precept-signin.dart';
import 'package:precept/precept/model/precept.dart';
import 'package:precept/precept/widget/customDisplayType.dart';
import 'package:precept/precept/widget/displayType.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  PreceptSignIn,
  Backend,
  CustomDisplayType,
  DisplayType,
  Precept,
  PreceptComponent,
  PreceptRoute,
  PreceptPage,
  PreceptSection,
  PreceptWidget,
  PreceptField,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
