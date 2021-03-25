import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/preceptItem.dart';
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
/// [table] is the equivalent of something like a table name, (class in Back4App, collection path for Firestore)
/// It does not always need to be specified explicitly - it may be derived from whatever is used to select the required data.
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
/// [script] is the GraphQL script, and typically needs to be expressed as a Dart 'raw String', see:
/// https://dart.dev/guides/language/language-tour (search for 'raw').  This makes sure none of the
/// GraphQL syntax gets lost during interpolation by Dart.
///
///
///
abstract class PQuery extends PreceptItem {
  final Map<String, dynamic> variables;
  final List<String> propertyReferences;

  PQuery({
    this.variables = const {},
    this.propertyReferences = const [],
  });

  @JsonKey(ignore: true)
  PDocument get schema => (parent as PCommon).dataProvider.schema.documents[table];

  String get table;

  void doValidate(List<ValidationMessage> messages, {int index = -1}) {}
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGQuery extends PQuery {
  final String script;

  PGQuery({
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    @required this.script,
  }) : super(
          propertyReferences: propertyReferences,
          variables: variables,
        );

  factory PGQuery.fromJson(Map<String, dynamic> json) => _$PGQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PGQueryToJson(this);

  @override
  // TODO: implement table
  String get table => throw UnimplementedError();
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPQuery extends PQuery {
  final String fields;
  final String table;
  final Map<String, String> types;

  PPQuery({
    this.fields = '',
    this.types=const {},
    this.table,
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
  }) : super(
          propertyReferences: propertyReferences,
          variables: variables,
        );

  factory PPQuery.fromJson(Map<String, dynamic> json) => _$PPQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PPQueryToJson(this);
}

/// Retrieves a single document using a [DocumentId]
@JsonSerializable(nullable: true, explicitToJson: true)
class PGet extends PQuery {
  final DocumentId documentId;

  PGet({
    @required this.documentId,
    @required String script,
    @required String fields,
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    Map<String, dynamic> params = const {},
  }) : super(
          propertyReferences: propertyReferences,
          variables: variables,
        );

  factory PGet.fromJson(Map<String, dynamic> json) => _$PGetFromJson(json);

  Map<String, dynamic> toJson() => _$PGetToJson(this);

  String get table => documentId.path;

  @override
  void doValidate(List<ValidationMessage> messages, {int index = -1}) {
    if (documentId == null) {
      messages.add(ValidationMessage(item: this, msg: "PDataGet must define a documentId"));
    }
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGetStream extends PQuery {
  final DocumentId documentId;

  PGetStream({
    @required String script,
    @required String fields,
    Map<String, dynamic> arguments = const {},
    List<String> propertyReferences = const [],
    @required this.documentId,
    Map<String, dynamic> params = const {},
  }) : super(
          propertyReferences: propertyReferences,
          variables: arguments,
        );

  String get table => documentId.path;

  factory PGetStream.fromJson(Map<String, dynamic> json) => _$PGetStreamFromJson(json);

  Map<String, dynamic> toJson() => _$PGetStreamToJson(this);
}
