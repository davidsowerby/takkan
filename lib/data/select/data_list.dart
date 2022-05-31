import 'package:freezed_annotation/freezed_annotation.dart';

import '../../panel/panel.dart';
import 'data.dart';

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
class DataList implements IDataList {

  const DataList({
    this.liveConnect = false,
    required this.name,
    this.pageLength = 20,
    this.caption,
  });

  factory DataList.fromJson(Map<String, dynamic> json) =>
      _$DataListFromJson(json);
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
    final String name;
  @override
  final String? caption;

  Map<String, dynamic> toJson() => _$DataListToJson(this);
}

/// A list of documents identified by fixed [objectId]s
@JsonSerializable(explicitToJson: true)
class DataListById implements IDataList {

  const DataListById({
    required this.objectIds,
    this.liveConnect = false,
    this.pageLength = 20,
    required this.name,
    this.caption,
  });

  factory DataListById.fromJson(Map<String, dynamic> json) =>
      _$DataListByIdFromJson(json);
  final List<String> objectIds;
  @override
  final bool liveConnect;
  @override
    final String name;
  @override
  final String? caption;
  @override
  final int pageLength;

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  Map<String, dynamic> toJson() => _$DataListByIdToJson(this);
}

/// A list of documents retrieved from a cloud function identified
/// by [cloudFunctionName].  Unlike other [Data] implementations,
/// no [name] is needed, as the [cloudFunctionName] is used in its place.
@JsonSerializable(explicitToJson: true)
class DataListByFunction implements IDataList {

  const DataListByFunction({
    required this.cloudFunctionName,
    this.pageLength = 20,
    this.params = const {},
    this.liveConnect = false,
    this.caption,
  });

  factory DataListByFunction.fromJson(Map<String, dynamic> json) =>
      _$DataListByFunctionFromJson(json);
  final Map<String, dynamic> params;
  final String cloudFunctionName;
  @override
  final bool liveConnect;

  @override
  final String? caption;
  @override
  final int pageLength;

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  @override
    String get name=> cloudFunctionName;
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
class DataListByFilter implements IDataList {

  const DataListByFilter({
    required this.script,
    this.cloudFunctionName,
    this.liveConnect = false,
    required this.name,
    this.caption,
    this.pageLength = 20,
  });

  factory DataListByFilter.fromJson(Map<String, dynamic> json) =>
      _$DataListByFilterFromJson(json);
  final String script;
  final String? cloudFunctionName;
  @override
  final bool liveConnect;
  @override
  final int pageLength;
  @override
    final String name;
  @override
  final String? caption;

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  Map<String, dynamic> toJson() => _$DataListByFilterToJson(this);
}

/// [script] must be a valid GraphQL script which returns a list of 0..n documents
@JsonSerializable(explicitToJson: true)
class DataListByGQL implements IDataList {

  const DataListByGQL({
    required this.script,
    this.liveConnect = false,
    required this.name,
    this.caption,
    this.pageLength = 20,
  });

  factory DataListByGQL.fromJson(Map<String, dynamic> json) =>
      _$DataListByGQLFromJson(json);
  final String script;
  @override
  final bool liveConnect;
  @override
    final String name;
  @override
  final String? caption;
  @override
  final int pageLength;

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  Map<String, dynamic> toJson() => _$DataListByGQLToJson(this);
}
