import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/graphqlDelegate.dart';
import 'package:precept_script/data/provider/restDelegate.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';
import 'package:precept_script/signin/signIn.dart';
import 'package:precept_script/validation/message.dart';

part 'dataProvider.g.dart';

/// Either [schema] or [schemaSource] can be set.
///
/// [schema] can be set directly during development, [schemaSource] is required for production use.
///
/// If [schema] is not set, it is loaded on demand from the configuration specified by [schemaSource]
/// The presence of [schema] should therefore be tested before using it.
///
/// [headerKeys] for HTTP clients can be specified here or in [restDelegate]
/// or [graphQLDelegate] as required. These are merged by the delegate implementation.
///
/// If users need to be authenticated for this Data Provider,  [useAuthenticator]
/// should be true.  The default is false, because the DefaultDataProvider (which
/// which collaborates with this configuration) does not provide authentication
///
/// [providerName] is fixed by the implementation, primarily to help with debugging
///
@JsonSerializable(explicitToJson: true)
class PDataProvider extends PreceptItem {
  final PSignInOptions signInOptions;
  final PSignIn signIn;
  final PConfigSource configSource;
  final String providerName;

  @JsonKey(ignore: true)
  PSchema? _schema;
  final PSchemaSource? schemaSource;
  final String sessionTokenKey;
  final Delegate defaultDelegate;
  final PGraphQL? graphQLDelegate;
  final PRest? restDelegate;
  final bool useAuthenticator;

  @JsonKey(ignore: true)
  PSchema get schema {
    if (_schema == null) {
      throw PreceptException(
          'Schema must not be null now - has PDataProvider.init() been called?');
    }
    return _schema!;
  }

  set schema(value) => _schema = value;

  PDataProvider({
    required this.providerName,
    this.useAuthenticator = false,
    this.graphQLDelegate,
    this.restDelegate,
    required this.sessionTokenKey,
    required this.configSource,
    this.defaultDelegate = Delegate.graphQl,
    this.signInOptions = const PSignInOptions(),
    PSchema? schema,
    this.schemaSource,
    this.signIn = const PSignIn(),
    String? id,
  })  : _schema = schema,
        super(id: id);

  doInit(PScript script, PreceptItem parent, int index,
      {bool useCaptionsAsIds = true}) async {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    if (schemaSource != null) {
      schemaSource!.doInit(script, parent, index);
    }
    if (_schema == null) {
      if (schemaSource == null) {
        throw PreceptException(
            'If a Schema is not defined, a schema source must be');
      }

      final schemaLoader = inject<PreceptSchemaLoader>();
      _schema = await schemaLoader.load(schemaSource!);
    }
    schema.init();
  }

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (_schema == null && schemaSource == null) {
      messages.add(ValidationMessage(
          item: this,
          msg: "Either 'schema' or 'schemaSource' must be specified"));
    }
  }

  PDocument documentSchema({required String documentSchemaName}) {
    final PDocument? documentSchema = schema.documents[documentSchemaName];
    if (documentSchema == null) {
      String msg = "document schema '$documentSchemaName' not found";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return documentSchema;
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (schemaSource != null) schemaSource?.walk(visitors);
    if (_schema != null) _schema?.walk(visitors);
    graphQLDelegate?.walk(visitors);
    this.restDelegate?.walk(visitors);
  }

  /// referring to the id of a document, this can be overridden, by specific implementations.
  /// Back4App for example, uses 'objectId'
  String get idPropertyName => 'id';

  factory PDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PDataProviderToJson(this);
}

/// [segment] and [instance] together define which part **precept.json** is used to
/// configure a [DataProvider] connection
@JsonSerializable(explicitToJson: true)
class PConfigSource {
  final String segment;
  final String instance;

  const PConfigSource({required this.segment, required this.instance});

  @override
  String toString() {
    return '$segment:$instance';
  }

  factory PConfigSource.fromJson(Map<String, dynamic> json) =>
      _$PConfigSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PConfigSourceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PNoDataProvider extends PDataProvider {
  PNoDataProvider({
    PSchema? schema,
  }) : super(
          providerName: 'NoDataProvider',
          signInOptions: const PSignInOptions(),
          signIn: const PSignIn(),
          schema: schema,
          configSource: PConfigSource(segment: 'none', instance: 'none'),
          schemaSource: PSchemaSource(segment: 'none', instance: 'none'),
          sessionTokenKey: 'No Data Provider',
        );

  factory PNoDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PNoDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PNoDataProviderToJson(this);

  doInit(PScript script, PreceptItem parent, int index,
      {bool useCaptionsAsIds = true}) {
    /// Set this first so super does not try to laod it
    _schema = PSchema(name: 'unnamed', version: PVersion(number: -1));
    super.doInit(script, parent, index);
  }
}

abstract class PreceptSchemaLoader {
  Future<PSchema> load(PSchemaSource source);
}
