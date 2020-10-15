library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:precept/precept/model/built_vehicle.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  BuiltVehicle,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
