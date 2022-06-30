import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/data/select/field_selector.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/takkan_item.dart';
import 'package:takkan_script/script/script.dart';

part 'query.g.dart';

/// This abstract base class is common for queries with an expected result of one document, or a List of documents.
///
/// Will eventually have the option to just return a Future or connect a Stream.
///
/// [queryName] is used to identify data-select results held in local storage, and also
/// as a lookup key if used as a named data-select in [Schema.namedQueries].
///
/// [fields] is a comma separated list of field names you want values to be returned
/// for, and applies only to GraphQL queries.  REST queries always return all fields.
/// There is an outstanding issue to automatically generate this list for GraphQL
/// queries. https://gitlab.com/takkan/takkan_script/-/issues/2
///
/// [propertyReferences] allow linking the data-select variables dynamically to other data accessible to the data-select.
/// The reference is relative to the [parentBinding] of the [TakkanPage], [Panel] or [Part] holding the data-select.
///
/// [variables] are also passed to data-select variables, and take the form of key-value pairs.  They may be defined
/// as part of the [Script] if the data-select is 'fixed', or originate in the [RouteSettings] passed to the [TakkanPage].
///
/// There are potentially therefore 3 sources of variables, which are combined into a single map in this order.
/// Thus, any duplicated keys will have the value provided by the lowest on this list:
///
/// 1. [variables] from page settings
/// 1. [propertyReferences]
/// 1. [variables] from [Script]
///
/// Both [propertyReferences] and [variables] may be specified, but if any keys match, then [propertyReferences]
/// will take precedence
///
///
abstract class Query extends TakkanItem {
  final Map<String, dynamic> variables;
  final List<String> propertyReferences;
  final QueryReturnType returnType;
  String queryName;
  final String documentSchema;

  Query({
    this.variables = const {},
    required this.documentSchema,
    this.propertyReferences = const [],
    this.returnType = QueryReturnType.futureItem,
    required this.queryName,
  });

  /// For queries, property property to lookup its data (data-select results) in local storage

  @override
  String get idAlternative => queryName;
}

/// A 'pure' GraphQL data-select.  [script] must contain a complete GraphQL script
/// Variable values can be added directly with [variables] or can be looked up from the [propertyReferences].
/// Both can be specified.  When used within the Takkan client, variables are combined with those
/// passed as page arguments.  They are combined in the following order of precedence:
///
/// 1. [Query.variables]
/// 1. Values looked up from the properties specified in [Query.propertyReferences]
/// 1. Values passed as [pageArguments]
///
/// [queryScript] is the GraphQL script, and typically needs to be expressed as a Dart 'raw String', see:
/// https://dart.dev/guides/language/language-tour (search for 'raw').  This makes sure none of the
/// GraphQL syntax gets lost during interpolation by Dart.
///
/// [table]and [documentSchema] have to be specified, but it is intended that it will be automatically derived
/// from the [script].  See  https://gitlab.com/takkan/takkan_script/-/issues/5
@JsonSerializable(explicitToJson: true)
class GraphQLQuery extends Query {
  final String queryScript;

  GraphQLQuery({
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    required String documentSchema,
    required this.queryScript,
    required String queryName,
    QueryReturnType returnType = QueryReturnType.futureItem,
  }) : super(
    queryName: queryName,
    propertyReferences: propertyReferences,
    variables: variables,
    returnType: returnType,
    documentSchema: documentSchema,
  );

  factory GraphQLQuery.fromJson(Map<String, dynamic> json) =>
      _$GraphQLQueryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GraphQLQueryToJson(this);
}

/// **EXPERIMENTAL** A currently very limited attempt to simplify the specification of a GraphQL data-select.
///
/// [types] defines the data types of [fields]
/// [fields] defines which field values should be returned
/// [table] is a general term to describe a table-like classification of data.  In Back4App this is the equivalent of 'Class'
///
/// Variable values can be added directly with [variables] or can be looked up from the [propertyReferences].
/// Both can be specified.  When used within the Takkan client, variables are combined with those
/// passed as page arguments.  They are combined in the following order of precedence:
///
/// 1. [Query.variables]
/// 1. Values looked up from the properties specified in [Query.propertyReferences]
/// 1. Values passed as [pageArguments]
///
/// [fields] and [types] must contain 'id' if data is going to be edited, so that data can be updated
@JsonSerializable(explicitToJson: true)
class PQuery extends GraphQLQuery {
  final String fields;
  final Map<String, String> types;

  PQuery({
    this.fields = '',
    this.types = const {},
    required String queryName,
    required String documentSchema,
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    QueryReturnType returnType = QueryReturnType.futureItem,
  }) : super(
    queryName: queryName,
    documentSchema: documentSchema,
    queryScript: '',
    propertyReferences: propertyReferences,
    variables: variables,
    returnType: returnType,
  );

  factory PQuery.fromJson(Map<String, dynamic> json) => _$PQueryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PQueryToJson(this);
}

/// Retrieves a single document using a [DocumentId]
///
///
@JsonSerializable(explicitToJson: true)
class GetDocument extends Query {
  final DocumentId documentId;
  final FieldSelector fieldSelector;

  GetDocument({
    this.fieldSelector = const FieldSelector(),
    required this.documentId,
    String? queryName,
    super.variables = const {},
    super.propertyReferences = const [],
  }) : super(
    queryName: queryName ?? 'get${documentId.fullReference}',
    documentSchema: documentId.documentClass,
    returnType: QueryReturnType.futureDocument,
  );

  factory GetDocument.fromJson(Map<String, dynamic> json) =>
      _$GetDocumentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetDocumentToJson(this);

  String get table => documentId.documentClass;
}

@JsonSerializable(explicitToJson: true)
class GetStream extends Query {
  final DocumentId documentId;

  GetStream({
    String? queryName,
    Map<String, dynamic> arguments = const {},
    List<String> propertyReferences = const [],
    required this.documentId,
  }) : super(
    propertyReferences: propertyReferences,
    documentSchema: documentId.documentClass,
    variables: arguments,
    queryName: queryName ?? 'get${documentId.fullReference}',
  );

  String get table => documentId.documentClass;

  factory GetStream.fromJson(Map<String, dynamic> json) =>
      _$GetStreamFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetStreamToJson(this);
}

/// xxxxDocument use the DataProvider ****Document methods instead of fetch methods
enum QueryReturnType {
  futureItem,
  futureList,
  streamItem,
  streamList,
  futureDocument,
  streamDocument,
  unexpected,
}
