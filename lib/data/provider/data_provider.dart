import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/data/provider/graphql_delegate.dart';
import 'package:precept_script/data/provider/rest_delegate.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/signin/sign_in.dart';

part 'data_provider.g.dart';

/// Either [schema] or [schemaSource] can be set.
///
/// [schema] can be set directly during development, [schemaSource] is required for production use.
///
/// If [schema] is not set, it is loaded on demand from the configuration specified by [schemaSource]
/// The presence of [schema] should therefore be tested before using it.
///
/// If users need to be authenticated for this Data Provider,  [useAuthenticator]
/// should be true.  The default is false, because the DefaultDataProvider (which
/// which collaborates with this configuration) does not provide authentication
///
@JsonSerializable(explicitToJson: true)
class PDataProvider extends PreceptItem {
  final PSignInOptions signInOptions;
  final PSignIn signIn;
  final PInstance instanceConfig;
  final Delegate defaultDelegate;
  final PGraphQL? graphQLDelegate;
  final PRest? restDelegate;
  final bool useAuthenticator;

  PDataProvider({
    this.useAuthenticator = false,
    this.graphQLDelegate,
    this.restDelegate,
    required this.instanceConfig,
    this.defaultDelegate = Delegate.rest,
    this.signInOptions = const PSignInOptions(),
    this.signIn = const PSignIn(),
    String? id,
  }) : super(id: id);


  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    graphQLDelegate?.walk(visitors);
    this.restDelegate?.walk(visitors);
  }

  factory PDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PDataProviderToJson(this);
}

/// [group] and [instance] together define which part **precept.json** is used to
/// configure a [DataProvider] connection
///
/// Any [group], but typically that used for the main app database, may choose to
/// treat its instances as stages - for example,'dev', 'test', 'qa' and 'prod'.
///
/// A [group] is then declared as 'staged' in *precept.json* (refer to precept_backend AppConfig)
/// A 'staged' group has the current stage set by the app main.dart or command line invocation.
///
/// This makes the explicit declaration of [instance] redundant for staged situations,
/// and is therefore nullable
@JsonSerializable(explicitToJson: true)
class PInstance {
  final String group;
  final String? instance;

  const PInstance({required this.group, this.instance});

  @override
  String toString() {
    return '$group:$instance';
  }

  factory PInstance.fromJson(Map<String, dynamic> json) =>
      _$PInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$PInstanceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PNoDataProvider extends PDataProvider {
  PNoDataProvider({
    PSchema? schema,
  }) : super(
    signInOptions: const PSignInOptions(),
          signIn: const PSignIn(),
          instanceConfig: PInstance(group: 'none', instance: 'none'),
        );

  factory PNoDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PNoDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PNoDataProviderToJson(this);
}

abstract class PreceptSchemaLoader {
  Future<PSchema> load(PSchemaSource source);
}
