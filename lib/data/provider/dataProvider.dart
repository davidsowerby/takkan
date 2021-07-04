import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
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
@JsonSerializable(explicitToJson: true)
class PDataProvider extends PreceptItem {
  final PSignInOptions signInOptions;
  final PSignIn signIn;
  final PConfigSource configSource;

  @JsonKey(ignore: true)
  PSchema? _schema;
  final PSchemaSource? schemaSource;
  final bool checkHealthOnConnect;
  final String sessionTokenKey;
  final List<String> headerKeys;
  final String documentEndpoint;
  final CloudInterface defaultDelegate;
  final CloudInterface authenticatorDelegate;
  final bool useGraphQLDelegate;
  final bool useRestDelegate;

  @JsonKey(ignore: true)
  PSchema get schema {
    if (_schema == null) {
      throw PreceptException(
          'Schema must not be null now - has init() been called?');
    }
    return _schema!;
  }

  set schema(value) => _schema = value;

  PDataProvider({
    required this.headerKeys,
    required this.documentEndpoint,
    required this.sessionTokenKey,
    required this.configSource,
    this.useGraphQLDelegate = true,
    this.useRestDelegate = true,
    this.defaultDelegate = CloudInterface.graphQL,
    this.authenticatorDelegate = CloudInterface.graphQL,
    this.checkHealthOnConnect = false,
    this.signInOptions = const PSignInOptions(),
    PSchema? schema,
    this.schemaSource,
    this.signIn = const PSignIn(),
    String? id,
  })  : _schema = schema,
        super(id: id);

  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) async {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    if (_schema == null) {
      if (schemaSource == null) {
        throw PreceptException(
            'If a Schema is not defined, a schema source must be');
      }
      schemaSource!.doInit(script, parent, index);
      final schemaLoader = inject<PreceptSchemaLoader>();
      _schema = await schemaLoader.load(schemaSource!);
    }
    schema.init();
  }

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (_schema == null && schemaSource == null) {
      messages.add(ValidationMessage(
          item: this, msg: "Either 'schema' or 'schemaSource' must be specified"));
    }
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (schemaSource != null) schemaSource?.walk(visitors);
  }

  /// This can be overridden, because Back4App for example, uses the objectId field value
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

  factory PConfigSource.fromJson(Map<String, dynamic> json) => _$PConfigSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PConfigSourceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PNoDataProvider extends PDataProvider {
  PNoDataProvider()
      : super(
          documentEndpoint: '',
          signInOptions: const PSignInOptions(),
          signIn: const PSignIn(),
          headerKeys: const [],
          configSource: PConfigSource(segment: 'none', instance: 'none'),
          schemaSource: PSchemaSource(segment: 'none', instance: 'none'),
          sessionTokenKey: 'No Data Provider',
        );

  factory PNoDataProvider.fromJson(Map<String, dynamic> json) => _$PNoDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PNoDataProviderToJson(this);

  doInit(PScript script, PreceptItem parent, int index,
      {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index);
    _schema = PSchema(name: 'unnamed');
  }
}

abstract class PreceptSchemaLoader {
  Future<PSchema> load(PSchemaSource source);
}

enum CloudInterface { rest, graphQL }
