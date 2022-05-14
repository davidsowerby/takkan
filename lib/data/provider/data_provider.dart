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
class DataProvider extends PreceptItem {
  final SignInOptions signInOptions;
  final SignIn signIn;
  final AppInstance instanceConfig;
  final Delegate defaultDelegate;
  final GraphQL? graphQLDelegate;
  final Rest restDelegate;
  final bool useAuthenticator;

  DataProvider({
    this.useAuthenticator = false,
    this.graphQLDelegate,
    this.restDelegate = const Rest(),
    required this.instanceConfig,
    this.defaultDelegate = Delegate.rest,
    this.signInOptions = const SignInOptions(),
    this.signIn = const SignIn(),
    String? id,
  }) : super(id: id);

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    graphQLDelegate?.walk(visitors);
    this.restDelegate.walk(visitors);
  }

  factory DataProvider.fromJson(Map<String, dynamic> json) =>
      _$DataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$DataProviderToJson(this);
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
class AppInstance {
  final String group;
  final String? instance;

  const AppInstance({required this.group, this.instance});

  @override
  String toString() {
    return '$group:$instance';
  }

  factory AppInstance.fromJson(Map<String, dynamic> json) =>
      _$AppInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$AppInstanceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NullDataProvider extends DataProvider {
  NullDataProvider({
    Schema? schema,
  }) : super(
          signInOptions: const SignInOptions(),
          signIn: const SignIn(),
          instanceConfig: AppInstance(group: 'none', instance: 'none'),
        );

  factory NullDataProvider.fromJson(Map<String, dynamic> json) =>
      _$NullDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$NullDataProviderToJson(this);
}

abstract class PreceptSchemaLoader {
  Future<Schema> load(SchemaSource source);
}
