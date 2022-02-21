import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/query/field_selector.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'query.g.dart';

/// This abstract base class is common for queries with an expected result of one document, or a List of documents.
///
/// Will eventually have the option to just return a Future or connect a Stream.
///
/// [queryName] is used to identify query results held in local storage, and also
/// as a lookup key if used as a named query in [PSchema.namedQueries].
///
/// [fields] is a comma separated list of field names you want values to be returned
/// for, and applies only to GraphQL queries.  REST queries always return all fields.
/// There is an outstanding issue to automatically generate this list for GraphQL
/// queries. https://gitlab.com/precept1/precept_script/-/issues/2
///
/// [propertyReferences] allow linking the query variables dynamically to other data accessible to the query.
/// The reference is relative to the [parentBinding] of the [PreceptPage], [Panel] or [Part] holding the query.
///
/// [variables] are also passed to query variables, and take the form of key-value pairs.  They may be defined
/// as part of the [PScript] if the query is 'fixed', or originate in the [RouteSettings] passed to the [PreceptPage].
///
/// There are potentially therefore 3 sources of variables, which are combined into a single map in this order.
/// Thus, any duplicated keys will have the value provided by the lowest on this list:
///
/// 1. [variables] from page settings
/// 1. [propertyReferences]
/// 1. [variables] from [PScript]
///
/// Both [propertyReferences] and [variables] may be specified, but if any keys match, then [propertyReferences]
/// will take precedence
///
///
abstract class PQuery extends PreceptItem {
  final Map<String, dynamic> variables;
  final List<String> propertyReferences;
  final QueryReturnType returnType;
  String queryName;
  final String documentSchema;

  PQuery({
    this.variables = const {},
    required this.documentSchema,
    this.propertyReferences = const [],
    this.returnType = QueryReturnType.futureItem,
    required this.queryName,
  });

  /// For queries, property property to lookup its data (query results) in local storage

  String get idAlternative => queryName;
}

/// A 'pure' GraphQL query.  [script] must contain a complete GraphQL script
/// Variable values can be added directly with [variables] or can be looked up from the [propertyReferences].
/// Both can be specified.  When used within the Precept client, variables are combined with those
/// passed as page arguments.  They are combined in the following order of precedence:
///
/// 1. [PQuery.variables]
/// 1. Values looked up from the properties specified in [PQuery.propertyReferences]
/// 1. Values passed as [pageArguments]
///
/// [queryScript] is the GraphQL script, and typically needs to be expressed as a Dart 'raw String', see:
/// https://dart.dev/guides/language/language-tour (search for 'raw').  This makes sure none of the
/// GraphQL syntax gets lost during interpolation by Dart.
///
/// [table]and [documentSchema] have to be specified, but it is intended that it will be automatically derived
/// from the [script].  See  https://gitlab.com/precept1/precept_script/-/issues/5
@JsonSerializable(explicitToJson: true)
class PGraphQLQuery extends PQuery {
  final String queryScript;

  PGraphQLQuery({
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

  factory PGraphQLQuery.fromJson(Map<String, dynamic> json) =>
      _$PGraphQLQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PGraphQLQueryToJson(this);
}

/// **EXPERIMENTAL** A currently very limited attempt to simplify the specification of a GraphQL query.
///
/// [types] defines the data types of [fields]
/// [fields] defines which field values should be returned
/// [table] is a general term to describe a table-like classification of data.  In Back4App this is the equivalent of 'Class'
///
/// Variable values can be added directly with [variables] or can be looked up from the [propertyReferences].
/// Both can be specified.  When used within the Precept client, variables are combined with those
/// passed as page arguments.  They are combined in the following order of precedence:
///
/// 1. [PQuery.variables]
/// 1. Values looked up from the properties specified in [PQuery.propertyReferences]
/// 1. Values passed as [pageArguments]
///
/// [fields] and [types] must contain 'id' if data is going to be edited, so that data can be updated
@JsonSerializable(explicitToJson: true)
class PPQuery extends PGraphQLQuery {
  final String fields;
  final Map<String, String> types;

  PPQuery({
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

  factory PPQuery.fromJson(Map<String, dynamic> json) =>
      _$PPQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PPQueryToJson(this);
}

/// Retrieves a single document using a [DocumentId]
///
///
@JsonSerializable(explicitToJson: true)
class PGetDocument extends PQuery {
  final DocumentId documentId;
  final String documentSchema;
  final FieldSelector fieldSelector;

  PGetDocument({
    this.fieldSelector = const FieldSelector(),
    required this.documentId,
    required this.documentSchema,
    String? queryName,
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    Map<String, dynamic> params = const {},
  }) : super(
          queryName: queryName ?? 'get${documentId.fullReference}',
          documentSchema: documentId.path,
          propertyReferences: propertyReferences,
          variables: variables,
          returnType: QueryReturnType.futureDocument,
        );

  factory PGetDocument.fromJson(Map<String, dynamic> json) =>
      _$PGetDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PGetDocumentToJson(this);

  String get table => documentId.path;


}

@JsonSerializable(explicitToJson: true)
class PGetStream extends PQuery {
  final DocumentId documentId;

  PGetStream({
    String? queryName,
    Map<String, dynamic> arguments = const {},
    List<String> propertyReferences = const [],
    required this.documentId,
    Map<String, dynamic> params = const {},
  }) : super(
    propertyReferences: propertyReferences,
          documentSchema: documentId.path,
          variables: arguments,
          queryName: queryName ?? 'get${documentId.fullReference}',
        );

  String get table => documentId.path;

  factory PGetStream.fromJson(Map<String, dynamic> json) =>
      _$PGetStreamFromJson(json);

  Map<String, dynamic> toJson() => _$PGetStreamToJson(this);
}

/// xxxxDocument use the DataProvider ****Document methods instead of fetch methods
enum QueryReturnType {
  futureItem,
  futureList,
  streamItem,
  streamList,
  futureDocument,
  streamDocument
}
