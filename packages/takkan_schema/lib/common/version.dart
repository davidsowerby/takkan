import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../schema/schema.dart';
import 'exception.dart';

part 'version.g.dart';

/// Used by [Script] and [Schema] to record current and deprecated versions
@JsonSerializable(explicitToJson: true)
class Version extends Equatable {
  const Version({
    required this.versionIndex,
    this.label = '',
    this.status = VersionStatus.development,
  });

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);
  final int versionIndex;
  final String label;
  final VersionStatus status;

  Map<String, dynamic> toJson() => _$VersionToJson(this);

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [versionIndex, label, status];

  /// returns a new instance with status changed to [newStatus]
  Version withStatus(VersionStatus newStatus) {
    return Version(
      versionIndex: versionIndex,
      label: label,
      status: newStatus,
    );
  }
}

/// Meaning:
///
/// [released] - a fully released, current, version.  There can only be one
/// version at this status
/// [alpha] - released, but only at alpha stage
/// [beta] - released, but at beta stage
/// [deprecated] - still supported but will be [expired] at some point.  Better
/// to move to the [released] version
/// [expired] - no longer supported, although it was once [released].  Usually
/// the next step after [deprecated]
/// [development] - pre-release,and should only be used in development or test
/// [excluded] - excluded completely, usually without being released as a result
/// of failed or discarded development.  Diffs with this status are ignored when
/// building a full [Schema] from [SchemaDiff] instances and are retained purely
/// for reference
enum VersionStatus {
  alpha,
  beta,
  released,
  deprecated,
  excluded,
  expired,
  development
}

extension VersionStatusExtension on VersionStatus {
  /// Versions which could be in use by end user clients
  static Set<VersionStatus> deployed = {
    VersionStatus.alpha,
    VersionStatus.beta,
    VersionStatus.released,
    VersionStatus.deprecated,
  };

  /// Versions which could be in use by end user clients or developers / testers
  static Set<VersionStatus> active = {
    VersionStatus.alpha,
    VersionStatus.beta,
    VersionStatus.released,
    VersionStatus.deprecated,
    VersionStatus.development,
  };

  /// Versions which can be used to build from [SchemaDiff] instances
  static Set<VersionStatus> valid = {
    VersionStatus.alpha,
    VersionStatus.beta,
    VersionStatus.released,
    VersionStatus.deprecated,
    VersionStatus.development,
    VersionStatus.expired,
  };

  bool get isDeployed => deployed.contains(this);

  bool get isNotDeployed => !isDeployed;

  bool get isActive => active.contains(this);

  bool get isNotActive => !isActive;

  bool get isValid => valid.contains(this);

  bool get isNotValid => !isValid;
}

/// Enables a developer to specify 'lifecycle' rules for changes to status
abstract class VersionStatusChangeRules {
  /// Depending on the implementation, returns false or throws an exception
  /// if the transition from [currentStatus] to [newStatus] is not allowed
  bool checkRules({
    required VersionStatus currentStatus,
    required VersionStatus newStatus,
    required bool isBaseVersion,
  });
  
  /// If true, when the status of a version is changed to [VersionStatus.released],
  /// the current [VersionStatus.released] version (if there is one) is changed 
  /// to [VersionStatus.deprecated]
  bool get maintainUniqueReleasedVersion;
}

/// This default implementation imposes very little constraint on changing
/// version status.  The only rules are:
///
/// - A [SchemaSet.baseVersion] cannot be excluded
///
class DefaultVersionStatusChangeRules implements VersionStatusChangeRules {
  const DefaultVersionStatusChangeRules();

  @override
  bool checkRules({
    required VersionStatus currentStatus,
    required VersionStatus newStatus,
    required bool isBaseVersion,
  }) {
    if (isBaseVersion){
      if (newStatus==VersionStatus.excluded){
        throw const TakkanException('Base version cannot be excluded');
      }
    }
    return true;
  }

  /// See [VersionStatusChangeRules.maintainUniqueReleasedVersion]
  @override
  bool get maintainUniqueReleasedVersion=>true;
}
