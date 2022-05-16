import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/schema/schema.dart';

part 'version.g.dart';

/// Used by [Script] and [Schema] to record current and deprecated versions
@JsonSerializable(explicitToJson: true)
class Version {
  final int number;
  final String label;
  final List<int> deprecated;

  const Version(
      {required this.number, this.label = '', this.deprecated = const []});

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);

  /// current version [number], combined with [deprecated]
  List<int> get activeVersions {
    final all = List<int>.from(deprecated, growable: true);
    all.insert(0, number);
    return all;
  }
}
