library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:precept/precept/model/precept-signin.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  PreceptSignIn,
  Backend,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
