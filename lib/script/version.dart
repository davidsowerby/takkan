import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

part 'version.g.dart';

/// Used by [PScript] and [PSchema] to record current and deprecated versions
@JsonSerializable(explicitToJson: true)
class PVersion {
  final int number;
  final String label;
  final List<int> deprecated;

  const PVersion(
      {required this.number, this.label = '', this.deprecated = const []});

  factory PVersion.fromJson(Map<String, dynamic> json) =>
      _$PVersionFromJson(json);

  Map<String, dynamic> toJson() => _$PVersionToJson(this);

  /// current version [number], combined with [deprecated]
  List<int> get activeVersions {
    final all = List<int>.from(deprecated, growable: true);
    all.insert(0, number);
    return all;
  }
}
