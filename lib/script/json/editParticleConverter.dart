import 'package:precept_script/common/exception.dart';
import 'package:precept_script/script/particle/pParticle.dart';
import 'package:precept_script/script/particle/pTextBox.dart';

class PEditParticleConverter {

  static final elementKey='-editParticle-';

  static PEditParticle fromJson(Map<String, dynamic> json) {
    final particleType = json[elementKey];
    switch (particleType) {
      case "PTextBox":
        return PTextBox.fromJson(json);
      default:
        throw PreceptException("Particle type '$particleType' not recognised");
    }
  }

  static Map<String, dynamic> toJson(PEditParticle object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap[elementKey] = type.toString();
    return jsonMap;
  }
}
