import 'package:json_annotation/json_annotation.dart';
import 'package:precept_schema/common/exception.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/particle/pParticle.dart';
import 'package:precept_script/script/particle/pText.dart';

class PReadParticleConverter {

  static final elementKey='-readParticle-';

  static PReadParticle fromJson(Map<String, dynamic> json) {
    final particleType = json[elementKey];
    switch (particleType) {
      case "PText":
        return PText.fromJson(json);
      default:
        throw PreceptException("Particle type '$particleType' not recognised");
    }
  }

  static Map<String, dynamic> toJson(PReadParticle object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap[elementKey] = type.toString();
    return jsonMap;
  }
}
