import 'package:json_annotation/json_annotation.dart';

import '../../page/page.dart';
import '../../panel/panel.dart';
import 'data_selector.dart';

part 'data_list.g.dart';

/// Various selectors which define how to retrieve a list of 0..n documents.
///
/// A selector relates to a specific document class, which is defined in the
/// [Page] or [Panel] which holds the selector in its 'dataSelectors' property.
///
/// Lists can be retrieved using:
///
/// - [DocListByFunction], which uses a user-defined server-side function
/// - [DocListByQuery], which defines the filter conditions in a code-like script
/// - [DocListByGQL], which defines a query in GraphQL script
///
/// [liveConnect] If true, a Stream of data is expected (equivalent to a Back4App LiveQuery), rather than a Future
///

/// A list of documents retrieved from a cloud function identified
/// by [cloudFunctionName].  Unlike other [DataSelector] implementations,
/// no [name] is needed, as the [cloudFunctionName] is used in its place.
@JsonSerializable(explicitToJson: true)
class DocListByFunction implements DocumentListSelector {
  const DocListByFunction({
    required this.cloudFunctionName,
    this.pageLength = 20,
    this.params = const {},
    this.liveConnect = false,
    this.caption,
  });

  factory DocListByFunction.fromJson(Map<String, dynamic> json) =>
      _$DocListByFunctionFromJson(json);
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
  String get name => cloudFunctionName;

  Map<String, dynamic> toJson() => _$DocListByFunctionToJson(this);
}

/// [queryScript] is a javascript-valid boolean statement, for example:
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
class DocListByQuery implements DocumentListSelector {
  const DocListByQuery({
    this.liveConnect = false,
    this.caption,
    this.pageLength = 20,
    required this.queryName,
  });

  factory DocListByQuery.fromJson(Map<String, dynamic> json) =>
      _$DocListByQueryFromJson(json);
  @override
  final bool liveConnect;
  @override
  final int pageLength;

  @override
  String get name => queryName;
  @override
  final String? caption;
  final String queryName;

  @override
  bool get isItem => false;

  @override
  bool get isList => true;

  Map<String, dynamic> toJson() => _$DocListByQueryToJson(this);
}

/// [script] must be a valid GraphQL script which returns a list of 0..n documents
@JsonSerializable(explicitToJson: true)
class DocListByGQL implements DocumentListSelector {
  const DocListByGQL({
    required this.script,
    this.liveConnect = false,
    required this.name,
    this.caption,
    this.pageLength = 20,
  });

  factory DocListByGQL.fromJson(Map<String, dynamic> json) =>
      _$DocListByGQLFromJson(json);
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

  Map<String, dynamic> toJson() => _$DocListByGQLToJson(this);
}
