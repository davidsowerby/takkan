import 'package:json_annotation/json_annotation.dart';

const String jsonClassKey = '-classKey-';

@JsonEnum(alwaysCreate: true)
enum IsReadOnly {
  @JsonValue('yes')
  yes,
  @JsonValue('no')
  no,
  @JsonValue('inherited')
  inherited
}
