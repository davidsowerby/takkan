import 'package:json_annotation/json_annotation.dart';



@JsonEnum(alwaysCreate: true)
enum IsReadOnly {
  @JsonValue('yes')
  yes,
  @JsonValue('no')
  no,
  @JsonValue('inherited')
  inherited
}

const String jsonClassKey = '-classKey-';
const String jsonValueKey = '-valueKey-';
