import 'package:json_annotation/json_annotation.dart';
import '../../page/page.dart';
import 'data_selector.dart';

part 'data_item.g.dart';

/// Defines a number of ways to retrieve a single document.
///
/// A selector relates to a specific document class, which is defined in the
/// [Page] or [Panel] which holds the selector in its 'dataSelectors' property.
///
/// A document can be retrieved using:
///
/// - [DocByFunction], which uses a user-defined server-side function
/// - [DocByQuery], which defines the filter conditions in a code-like script
/// - [DocByGQL], which defines a query in GraphQL script
///
/// [liveConnect] If true, a Stream of data is expected (equivalent to a Back4App LiveQuery), rather than a Future
///
///

/// A single document retrieved from a cloud function identified
/// by [cloudFunctionName].  Unlike other [DataSelector] implementations,
/// no [name] is needed, as the [cloudFunctionName] is used in its place.
@JsonSerializable(explicitToJson: true)
class DocByFunction implements DocumentSelector {
  const DocByFunction({
    required this.cloudFunctionName,
    this.params = const {},
    this.liveConnect = false,
    this.caption,
  });

  factory DocByFunction.fromJson(Map<String, dynamic> json) =>
      _$DocByFunctionFromJson(json);
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
  String get name => cloudFunctionName;

  Map<String, dynamic> toJson() => _$DocByFunctionToJson(this);
}

/// [queryScript] is a javascript-valid boolean statement, for example:
///
/// - 'membership==234567'
///
///  This will be restructured if necessary, and passed via a REST API call, or
///  generate a server-side Back4App cloud function.  In the latter case,
///  [name] is used as the function name and must therefore be a
///  valid Javascript function name
///
/// The function must return a single valid document
@JsonSerializable(explicitToJson: true)
class DocByQuery implements DocumentSelector {
  DocByQuery({
    this.liveConnect = false,
    this.caption,
    required this.queryName,
  });

  factory DocByQuery.fromJson(Map<String, dynamic> json) =>
      _$DocByQueryFromJson(json);

  final String  queryName;
  @override
  String get name=> queryName;
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

  Map<String, dynamic> toJson() => _$DocByQueryToJson(this);

}

/// [script] must be a valid GraphQL script which returns exactly one document
@JsonSerializable(explicitToJson: true)
class DocByGQL implements DocumentSelector {
  const DocByGQL({
    required this.script,
    this.liveConnect = false,
    required this.name,
    this.caption,
  });

  factory DocByGQL.fromJson(Map<String, dynamic> json) =>
      _$DocByGQLFromJson(json);
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

  Map<String, dynamic> toJson() => _$DocByGQLToJson(this);
}
