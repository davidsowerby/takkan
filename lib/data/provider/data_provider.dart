import 'package:json_annotation/json_annotation.dart';

import '../../schema/schema.dart';
import '../../script/takkan_item.dart';
import '../../signin/sign_in.dart';
import '../../util/visitor.dart';
import 'delegate.dart';
import 'graphql_delegate.dart';
import 'rest_delegate.dart';

part 'data_provider.g.dart';

/// If users need to be authenticated for this Data Provider,  [useAuthenticator]
/// should be true.  The default is false, because the DefaultDataProvider in
/// the lamin8_client package, which which collaborates with this configuration,
/// does not provide authentication
///
@JsonSerializable(explicitToJson: true)
class DataProvider extends TakkanItem {

  DataProvider({
    this.useAuthenticator = false,
    this.graphQLDelegate,
    this.restDelegate = const Rest(),
    required this.instanceConfig,
    this.defaultDelegate = Delegate.rest,
    this.signInOptions = const SignInOptions(),
    this.signIn = const SignIn(),
    super. id,
  }) ;

  factory DataProvider.fromJson(Map<String, dynamic> json) =>
      _$DataProviderFromJson(json);
  final SignInOptions signInOptions;
  final SignIn signIn;
  final AppInstance instanceConfig;
  final Delegate defaultDelegate;
  final GraphQL? graphQLDelegate;
  final Rest restDelegate;
  final bool useAuthenticator;

  @override
  void walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    graphQLDelegate?.walk(visitors);
    restDelegate.walk(visitors);
  }

  @override
  Map<String, dynamic> toJson() => _$DataProviderToJson(this);
}

/// [group] and [instance] together define which part **takkan.json** is used to
/// configure a [DataProvider] connection
///
/// Any [group], but typically that used for the main app database, may choose to
/// treat its instances as stages - for example,'dev', 'test', 'qa' and 'prod'.
///
/// A [group] is then declared as 'staged' in *takkan.json* (refer to takkan_backend AppConfig)
/// A 'staged' group has the current stage set by the app main.dart or command line invocation.
///
/// This makes the explicit declaration of [instance] redundant for staged situations,
/// and is therefore nullable
@JsonSerializable(explicitToJson: true)
class AppInstance {

  const AppInstance({required this.group, this.instance});

  factory AppInstance.fromJson(Map<String, dynamic> json) =>
      _$AppInstanceFromJson(json);
  final String group;
  final String? instance;

  @override
  String toString() {
    return '$group:$instance';
  }

  Map<String, dynamic> toJson() => _$AppInstanceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NullDataProvider extends DataProvider {
  NullDataProvider() : super(
          signInOptions: const SignInOptions(),
          signIn: const SignIn(),
          instanceConfig: const AppInstance(group: 'none', instance: 'none'),
        );

  factory NullDataProvider.fromJson(Map<String, dynamic> json) =>
      _$NullDataProviderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NullDataProviderToJson(this);
}

abstract class TakkanSchemaLoader {
  Future<Schema> load(SchemaSource source);
}
