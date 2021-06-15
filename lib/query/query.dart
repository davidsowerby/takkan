import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/data/provider/documentId.dart';
import 'package:precept_script/schema/field/queryResult.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'query.g.dart';

/// This abstract base class is common for queries with an expected result of one document, or a List of documents.
/// Results may be returned as either a Future or a Stream. Implementations are in broad categories of 'get',
/// Specifies how to retrieve a single document or a list of documents in a backend-neutral way
/// Supports various ways of identifying the document:
/// - 'get' with a document id
/// - 'select distinct' with criteria expressed in parameters
/// - 'select first'
/// - 'select last'
///
/// [querySchema] is used to look up the schema for the query, held in [PSchema.queries] and defined by
/// an instance of [PQuerySchema]. The [PQuerySchema.documentSchema] contains a reference to the s
/// chema for the document(s) returned by the query
///
/// [fields] is a comma separated list of field names you want values to be returned for.  There is an outstanding
/// issue to automatically generate this. https://gitlab.com/precept1/precept_script/-/issues/2
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
///
///
abstract class PQuery extends PreceptItem {
  final Map<String, dynamic> variables;
  final List<String> propertyReferences;
  final QueryReturnType returnType;
  final String querySchema;

  PQuery({
    this.variables = const {},
    this.propertyReferences = const [],
    this.returnType = QueryReturnType.futureSingle,
    required this.querySchema,
  });

  @JsonKey(ignore: true)
  PQuerySchema? get schema => (parent as PCommon).dataProvider?.schema.queries[querySchema];

  /// For queries, the name is used as a property to lookup its data (query results) in local storage
  String get property => querySchema;

  void doValidate(List<ValidationMessage> messages, {int index = -1}) {}
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
/// [script] is the GraphQL script, and typically needs to be expressed as a Dart 'raw String', see:
/// https://dart.dev/guides/language/language-tour (search for 'raw').  This makes sure none of the
/// GraphQL syntax gets lost during interpolation by Dart.
///
/// [table]and [documentSchema] have to be specified, but it is intended that it will be automatically derived
/// from the [script].  See  https://gitlab.com/precept1/precept_script/-/issues/5
@JsonSerializable(explicitToJson: true)
class PGQuery extends PQuery {
  final String script;

  PGQuery({
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    required this.script,
    required String querySchema,
    QueryReturnType returnType = QueryReturnType.futureSingle,
  }) : super(
          querySchema: querySchema,
          propertyReferences: propertyReferences,
          variables: variables,
          returnType: returnType,
        );

  factory PGQuery.fromJson(Map<String, dynamic> json) => _$PGQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PGQueryToJson(this);
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
class PPQuery extends PGQuery {
  final String fields;
  final Map<String, String> types;

  PPQuery({
    this.fields = '',
    this.types = const {},
    required String querySchema,
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    QueryReturnType returnType = QueryReturnType.futureSingle,
  }) : super(
    querySchema: querySchema,
          script: '',
          propertyReferences: propertyReferences,
          variables: variables,
          returnType: returnType,
        );

  factory PPQuery.fromJson(Map<String, dynamic> json) => _$PPQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PPQueryToJson(this);
}

/// Retrieves a single document using a [DocumentId]
@JsonSerializable(explicitToJson: true)
class PGetDocument extends PQuery {
  final DocumentId documentId;

  PGetDocument({
    required this.documentId,
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    Map<String, dynamic> params = const {},
  }) : super(
    querySchema: '',
          propertyReferences: propertyReferences,
          variables: variables,
        );

  factory PGetDocument.fromJson(Map<String, dynamic> json) => _$PGetDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PGetDocumentToJson(this);

  String get table => documentId.path;

  @override
  void doValidate(List<ValidationMessage> messages, {int index = -1}) {}
}

@JsonSerializable(explicitToJson: true)
class PGetStream extends PQuery {
  final DocumentId documentId;

  PGetStream({
    required String querySchema,
    Map<String, dynamic> arguments = const {},
    List<String> propertyReferences = const [],
    required this.documentId,
    Map<String, dynamic> params = const {},
  }) : super(
    propertyReferences: propertyReferences,
          variables: arguments,
          querySchema: querySchema,
        );

  String get table => documentId.path;

  factory PGetStream.fromJson(Map<String, dynamic> json) => _$PGetStreamFromJson(json);

  Map<String, dynamic> toJson() => _$PGetStreamToJson(this);
}

enum QueryReturnType { futureSingle, futureList, streamSingle, streamList }
