import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:precept_script/data/select/data.dart';

part 'multi.g.dart';

/// Defines how to retrieve a single document.
///
/// The default is to connect to the currently selected document (see DataRoot in *precept_client+).
/// Selection to become the current document is made, for example, by  tapping an entry in list of documents from a data-select,
/// use of a search panel etc.  Connection to a specific document can be made by specifying [objectId], or specifying a [cloudFunction]
/// which returns exactly one document.
///
/// If both are specified, [objectId] takes precedence over [cloudFunction]
///
/// [liveConnect] If true, a Stream of data is expected (equivalent to a Back4App LiveQuery), rather than a Future
///
/// NOTE: Only the [objectId] is required and not the full [DocumentId], because the document class is provided
/// by the parent [PPod].

@JsonSerializable(explicitToJson: true)
class PMulti implements PData {
  final bool liveConnect;
  final int pageLength;

  bool get isSingle => false;

  bool get isMulti => true;

  bool get isStatic => false;

  final String tag;
  final String? caption;

  const PMulti({
    this.liveConnect = false,
    this.tag = 'default',
    this.pageLength = 20,
    this.caption,
  });

  factory PMulti.fromJson(Map<String, dynamic> json) => _$PMultiFromJson(json);

  Map<String, dynamic> toJson() => _$PMultiToJson(this);
}

/// A single document identified by a fixed [objectId]
@JsonSerializable(explicitToJson: true)
class PMultiById implements PData {
  final List<String> objectIds;
  final bool liveConnect;
  final String tag;
  final String? caption;
  final int pageLength;

  const PMultiById({
    required this.objectIds,
    this.liveConnect = false,
    this.pageLength = 20,
    this.tag = 'default',
    this.caption,
  });

  @override
  bool get isSingle => false;

  @override
  bool get isMulti => true;

  factory PMultiById.fromJson(Map<String, dynamic> json) =>
      _$PMultiByIdFromJson(json);

  Map<String, dynamic> toJson() => _$PMultiByIdToJson(this);
}

/// A single document retrieved from a cloud function identified
/// by [cloudFunctionName]
@JsonSerializable(explicitToJson: true)
class PMultiByFunction implements PData {
  final Map<String, dynamic> params;
  final String cloudFunctionName;
  final bool liveConnect;
  final String tag;
  final String? caption;
  final int pageLength;

  const PMultiByFunction({
    required this.cloudFunctionName,
    this.pageLength = 20,
    this.params = const {},
    this.liveConnect = false,
    this.tag = 'default',
    this.caption,
  });

  @override
  bool get isSingle => false;

  @override
  bool get isMulti => true;

  factory PMultiByFunction.fromJson(Map<String, dynamic> json) =>
      _$PMultiByFunctionFromJson(json);

  Map<String, dynamic> toJson() => _$PMultiByFunctionToJson(this);
}

/// [script] is a javascript-valid boolean statement, for example:
///
/// - 'age >= 18 && isMember==true'
///
///  This will be restructured if necessary, and passed via a REST API call, or
///  generate a server-side Back4App cloud function.  In the latter case,
///  [cloudFunctionName] is used as the function name and must therefore be a
///  valid Javascript function name
@JsonSerializable(explicitToJson: true)
class PMultiByFilter implements PData {
  final String script;
  final String? cloudFunctionName;
  final bool liveConnect;
  final int pageLength;
  final String tag;
  final String? caption;

  const PMultiByFilter({
    required this.script,
    this.cloudFunctionName,
    this.liveConnect = false,
    this.tag = 'default',
    this.caption,
    this.pageLength=20,
  });

  @override
  bool get isSingle => false;

  @override
  bool get isMulti => true;



  factory PMultiByFilter.fromJson(Map<String, dynamic> json) =>
      _$PMultiByFilterFromJson(json);

  Map<String, dynamic> toJson() => _$PMultiByFilterToJson(this);
}

/// [script] must be a valid GraphQL script which returns exactly one document
@JsonSerializable(explicitToJson: true)
class PMultiByGQL implements PData {
  final String script;
  final bool liveConnect;
  final String tag;
  final String? caption;
  final int pageLength;

  const PMultiByGQL({
    required this.script,
    this.liveConnect = false,
    this.tag = 'default',
    this.caption,
    this.pageLength=20,
  });

  @override
  bool get isSingle => false;

  @override
  bool get isMulti => true;


  factory PMultiByGQL.fromJson(Map<String, dynamic> json) =>
      _$PMultiByGQLFromJson(json);

  Map<String, dynamic> toJson() => _$PMultiByGQLToJson(this);
}
