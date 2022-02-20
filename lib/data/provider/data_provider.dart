import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/graphql_delegate.dart';
import 'package:precept_script/data/provider/rest_delegate.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/signin/sign_in.dart';
import 'package:precept_script/validation/message.dart';

part 'data_provider.g.dart';

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
  final String sessionTokenKey;
  final Delegate defaultDelegate;
  final PGraphQL? graphQLDelegate;
  final PRest? restDelegate;
  final bool useAuthenticator;

  PDataProvider({
    required this.providerName,
    this.useAuthenticator = false,
    this.graphQLDelegate,
    this.restDelegate,
    required this.sessionTokenKey,
    required this.configSource,
    this.defaultDelegate = Delegate.graphQl,
    this.signInOptions = const PSignInOptions(),
    this.signIn = const PSignIn(),
    String? id,
  }) : super(id: id);

  doInit(PScript script, PreceptItem parent, int index,
      {bool useCaptionsAsIds = true}) async {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
  }

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
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
          configSource: PConfigSource(segment: 'none', instance: 'none'),
          sessionTokenKey: 'No Data Provider',
        );

  factory PNoDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PNoDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PNoDataProviderToJson(this);

  doInit(PScript script, PreceptItem parent, int index,
      {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index);
  }
}

abstract class PreceptSchemaLoader {
  Future<PSchema> load(PSchemaSource source);
}
