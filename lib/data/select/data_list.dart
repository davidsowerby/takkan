import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/panel/panel.dart';

part 'data_list.g.dart';

/// Defines how to retrieve a list of 0..n documents.
///
/// The default [DataList] returns all instances of the parent [Pod.documentClass],
/// which may not be a good idea if there are a lot of instances!
///
/// Other, restricted lists can be retrieved using:
///
/// - [DataListById]
/// - [DataListByFunction]
/// - [DataListByFilter]
/// - [DataListByGQL]
///
/// [liveConnect] If true, a Stream of data is expected (equivalent to a Back4App LiveQuery), rather than a Future
///

@JsonSerializable(explicitToJson: true)
class DataList implements Data {
  @override
  final bool liveConnect;
  @override
  final int pageLength;

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  bool get isStatic => false;

  @override
  final String tag;
  @override
  final String? caption;

  const DataList({
    this.liveConnect = false,
    this.tag = 'default',
    this.pageLength = 20,
    this.caption,
  });

  factory DataList.fromJson(Map<String, dynamic> json) =>
      _$DataListFromJson(json);

  Map<String, dynamic> toJson() => _$DataListToJson(this);
}

/// A list of documents identified by fixed [objectId]s
@JsonSerializable(explicitToJson: true)
class DataListById implements Data {
  final List<String> objectIds;
  @override
  final bool liveConnect;
  @override
  final String tag;
  @override
  final String? caption;
  @override
  final int pageLength;

  const DataListById({
    required this.objectIds,
    this.liveConnect = false,
    this.pageLength = 20,
    this.tag = 'default',
    this.caption,
  });

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  factory DataListById.fromJson(Map<String, dynamic> json) =>
      _$DataListByIdFromJson(json);

  Map<String, dynamic> toJson() => _$DataListByIdToJson(this);
}

/// A list of documents retrieved from a cloud function identified
/// by [cloudFunctionName]
@JsonSerializable(explicitToJson: true)
class DataListByFunction implements Data {
  final Map<String, dynamic> params;
  final String cloudFunctionName;
  @override
  final bool liveConnect;
  @override
  final String tag;
  @override
  final String? caption;
  @override
  final int pageLength;

  const DataListByFunction({
    required this.cloudFunctionName,
    this.pageLength = 20,
    this.params = const {},
    this.liveConnect = false,
    this.tag = 'default',
    this.caption,
  });

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  factory DataListByFunction.fromJson(Map<String, dynamic> json) =>
      _$DataListByFunctionFromJson(json);

  Map<String, dynamic> toJson() => _$DataListByFunctionToJson(this);
}

/// [script] is a javascript-valid boolean statement, for example:
///
/// - 'age >= 18 && isMember==true'
///
///  This will be restructured if necessary, and passed via a REST API call, or
///  generate a server-side Back4App cloud function.  In the latter case,
///  [cloudFunctionName] is used as the function name and must therefore be a
///  valid Javascript function name
///
/// The function must return a list.
@JsonSerializable(explicitToJson: true)
class DataListByFilter implements Data {
  final String script;
  final String? cloudFunctionName;
  @override
  final bool liveConnect;
  @override
  final int pageLength;
  @override
  final String tag;
  @override
  final String? caption;

  const DataListByFilter({
    required this.script,
    this.cloudFunctionName,
    this.liveConnect = false,
    this.tag = 'default',
    this.caption,
    this.pageLength = 20,
  });

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  factory DataListByFilter.fromJson(Map<String, dynamic> json) =>
      _$DataListByFilterFromJson(json);

  Map<String, dynamic> toJson() => _$DataListByFilterToJson(this);
}

/// [script] must be a valid GraphQL script which returns a list of 0..n documents
@JsonSerializable(explicitToJson: true)
class DataListByGQL implements Data {
  final String script;
  @override
  final bool liveConnect;
  @override
  final String tag;
  @override
  final String? caption;
  @override
  final int pageLength;

  const DataListByGQL({
    required this.script,
    this.liveConnect = false,
    this.tag = 'default',
    this.caption,
    this.pageLength = 20,
  });

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  factory DataListByGQL.fromJson(Map<String, dynamic> json) =>
      _$DataListByGQLFromJson(json);

  Map<String, dynamic> toJson() => _$DataListByGQLToJson(this);
}
