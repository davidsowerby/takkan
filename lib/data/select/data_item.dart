import 'package:freezed_annotation/freezed_annotation.dart';
import '../../page/page.dart';
import 'data.dart';

part 'data_item.g.dart';

/// Defines how to retrieve a single document.
///
/// [name] must be unique within the [Page] it is declared, and must not contain a '/'
///
/// The default [DataItem] connects to the currently selected document (see DocumentPage in *takkan_client+).
/// Selection of the current document is made, for example, by use of a search panel etc.
///
/// See below for other options for selection, such as [DataItemById], [DataItemByFunction],
/// [DataItemByFilter] and [DataItemByGQL]
///
@JsonSerializable(explicitToJson: true)
class DataItem implements IDataItem {

  const DataItem({
    this.liveConnect = false,
    required this.name,
    this.caption,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) =>
      _$DataItemFromJson(json);
  @override
  final bool liveConnect;

  @override
  bool get isItem => true;

  @override
  bool get isList => false;

  bool get isStatic => false;

  @override
  final String name;
  @override
  final String? caption;

  Map<String, dynamic> toJson() => _$DataItemToJson(this);

  @override
  int get pageLength => 1;
}

/// A single document identified by a fixed [objectId]
@JsonSerializable(explicitToJson: true)
class DataItemById implements IDataItem {

  const DataItemById({
    required this.objectId,
    this.liveConnect = false,
    this.caption,
    required this.name,
  });

  factory DataItemById.fromJson(Map<String, dynamic> json) =>
      _$DataItemByIdFromJson(json);
  final String objectId;
  @override
  final bool liveConnect;
  @override
  final String name;
  @override
  final String? caption;

  @override
  bool get isItem => true;

  @override
  bool get isList => false;

  @override
  int get pageLength => 1;

  Map<String, dynamic> toJson() => _$DataItemByIdToJson(this);
}

/// A single document retrieved from a cloud function identified
/// by [cloudFunctionName].  Unlike other [Data] implementations,
/// no [name] is needed, as the [cloudFunctionName] is used in its place.
@JsonSerializable(explicitToJson: true)
class DataItemByFunction implements IDataItem {

  const DataItemByFunction({
    required this.cloudFunctionName,
    this.params = const {},
    this.liveConnect = false,
    this.caption,
  }) ;

  factory DataItemByFunction.fromJson(Map<String, dynamic> json) =>
      _$DataItemByFunctionFromJson(json);
  final Map<String, dynamic> params;
  final String cloudFunctionName;
  @override
  final bool liveConnect;

  @override
  final String? caption;

  @override
  bool get isItem => true;

  @override
  bool get isList => false;

  @override
  int get pageLength => 1;

  @override
  String get name=> cloudFunctionName;

  Map<String, dynamic> toJson() => _$DataItemByFunctionToJson(this);
}

/// [script] is a javascript-valid boolean statement, for example:
///
/// - 'membership==234567'
///
///  This will be restructured if necessary, and passed via a REST API call, or
///  generate a server-side Back4App cloud function.  In the latter case,
///  [cloudFunctionName] is used as the function name and must therefore be a
///  valid Javascript function name
///
/// The function must return a single valid document
@JsonSerializable(explicitToJson: true)
class DataItemByFilter implements IDataItem {

  const DataItemByFilter({
    required this.script,
    required this.name,
    this.liveConnect = false,

    this.caption,
  });

  factory DataItemByFilter.fromJson(Map<String, dynamic> json) =>
      _$DataItemByFilterFromJson(json);
  final String script;
  final String name;
  @override
  final bool liveConnect;

  @override
  final String? caption;

  @override
  bool get isItem => true;

  @override
  bool get isList => false;

  @override
  int get pageLength => 1;



  Map<String, dynamic> toJson() => _$DataItemByFilterToJson(this);
}

/// [script] must be a valid GraphQL script which returns exactly one document
@JsonSerializable(explicitToJson: true)
class DataItemByGQL implements IDataItem {

  const DataItemByGQL({
    required this.script,
    this.liveConnect = false,
    required this.name,
    this.caption,
  });

  factory DataItemByGQL.fromJson(Map<String, dynamic> json) =>
      _$DataItemByGQLFromJson(json);
  final String script;
  @override
  final bool liveConnect;
  @override
  final String name;
  @override
  final String? caption;

  @override
  bool get isItem => true;

  @override
  bool get isList => false;

  @override
  int get pageLength => 1;

  Map<String, dynamic> toJson() => _$DataItemByGQLToJson(this);
}
