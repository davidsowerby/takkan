import 'package:precept_script/common/exception.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/particle/pParticle.dart';
import 'package:precept_script/script/particle/pTextBox.dart';

class PDataProviderConverter {

  static final elementKey='-dataProvider-';

  static PDataProvider fromJson(Map<String, dynamic> json) {
    final providerType = json[elementKey];
    switch (providerType) {
      case "PRestDataProvider":
        return PRestDataProvider.fromJson(json);
      default:
        throw PreceptException("DataProvider type '$providerType' not recognised");
    }
  }

  static Map<String, dynamic> toJson(PDataProvider object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap[elementKey] = type.toString();
    return jsonMap;
  }
}
