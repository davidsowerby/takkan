import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:precept_script/data/select/data.dart';

part 'single.g.dart';

/// Defines how to retrieve a single document.
///
/// [PSingle] connects to the currently selected document (see DataRoot in *precept_client+).
/// Selection of the current document is made, for example, by
/// use of a search panel etc.
///
/// See below for other options for selection, such as [PSingleById], [PSingleByFunction],
/// [PSingleByFilter] and [PSingleByGQL]
@JsonSerializable(explicitToJson: true)
class PSingle implements PData {
  final bool liveConnect;

  bool get isSingle => true;

  bool get isMulti => false;

  bool get isStatic => false;

  final String tag;
  final String? caption;

  const PSingle({this.liveConnect = false, this.tag = 'default',     this.caption,});

  factory PSingle.fromJson(Map<String, dynamic> json) =>
      _$PSingleFromJson(json);

  Map<String, dynamic> toJson() => _$PSingleToJson(this);

  @override
  int get pageLength => 1;
}

/// A single document identified by a fixed [objectId]
@JsonSerializable(explicitToJson: true)
class PSingleById implements PData {
  final String objectId;
  final bool liveConnect;
  final String tag;
  final String? caption;

  const PSingleById({
    required this.objectId,
    this.liveConnect = false,
     this.caption,
    this.tag = 'default',
  });

  @override
  bool get isSingle => true;

  @override
  bool get isMulti => false;


  @override
  int get pageLength => 1;

  factory PSingleById.fromJson(Map<String, dynamic> json) =>
      _$PSingleByIdFromJson(json);

  Map<String, dynamic> toJson() => _$PSingleByIdToJson(this);


}

/// A single document retrieved from a cloud function identified
/// by [cloudFunctionName]
@JsonSerializable(explicitToJson: true)
class PSingleByFunction implements PData {
  final Map<String, dynamic> params;
  final String cloudFunctionName;
  final bool liveConnect;
  final String tag;
  final String? caption;


  const PSingleByFunction({
    required this.cloudFunctionName,
    this.params = const {},
    this.liveConnect = false,
    this.tag = 'default',
     this.caption,
  });

  @override
  bool get isSingle => true;

  @override
  bool get isMulti => false;


  @override
  int get pageLength => 1;

  factory PSingleByFunction.fromJson(Map<String, dynamic> json) =>
      _$PSingleByFunctionFromJson(json);

  Map<String, dynamic> toJson() => _$PSingleByFunctionToJson(this);
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
class PSingleByFilter implements PData {
  final String script;
  final String? cloudFunctionName;
  final bool liveConnect;
  final String tag;
  final String? caption;

  const PSingleByFilter({
    required this.script,
    this.cloudFunctionName,
    this.liveConnect = false,
    this.tag = 'default',
     this.caption,
  });

  @override
  bool get isSingle => true;

  @override
  bool get isMulti => false;



  @override
  int get pageLength => 1;

  factory PSingleByFilter.fromJson(Map<String, dynamic> json) =>
      _$PSingleByFilterFromJson(json);

  Map<String, dynamic> toJson() => _$PSingleByFilterToJson(this);
}

/// [script] must be a valid GraphQL script which returns exactly one document
@JsonSerializable(explicitToJson: true)
class PSingleByGQL implements PData {
  final String script;
  final bool liveConnect;
  final String tag;
  final String? caption;

  const PSingleByGQL({
    required this.script,
    this.liveConnect = false,
    this.tag = 'default',
     this.caption,
  });

  @override
  bool get isSingle => true;

  @override
  bool get isMulti => false;



  @override
  int get pageLength => 1;

  factory PSingleByGQL.fromJson(Map<String, dynamic> json) =>
      _$PSingleByGQLFromJson(json);

  Map<String, dynamic> toJson() => _$PSingleByGQLToJson(this);
}