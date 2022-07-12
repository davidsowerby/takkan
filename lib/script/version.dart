import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../schema/schema.dart';

part 'version.g.dart';

/// Used by [Script] and [Schema] to record current and deprecated versions
@JsonSerializable(explicitToJson: true)
class Version extends Equatable {

  const Version(
      {required this.number, this.label = '', this.deprecated = const []});

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);
  final int number;
  final String label;
  final List<int> deprecated;

  Map<String, dynamic> toJson() => _$VersionToJson(this);

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [number, label, deprecated];

  /// current version [number], combined with [deprecated]
  List<int> get activeVersions {
    final all = List<int>.from(deprecated);
    all.insert(0, number);
    return all;
  }
}
