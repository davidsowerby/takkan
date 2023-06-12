// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/takkan/takkan_element.dart';
import 'package:takkan_schema/util/walker.dart';

import '../../signin/sign_in.dart';
import 'delegate.dart';
import 'graphql_delegate.dart';
import 'rest_delegate.dart';

part 'data_provider.g.dart';

/// If users need to be authenticated for this Data Provider,  [useAuthenticator]
/// should be true.  The default is false
///
@JsonSerializable(explicitToJson: true)
class DataProvider extends TakkanElement {
  DataProvider({
    this.useAuthenticator = false,
    this.graphQLDelegate,
    this.restDelegate = const Rest(),
    required this.instanceConfig,
    this.defaultDelegate = Delegate.rest,
    this.signInOptions = const SignInOptions(),
    this.signIn = const SignIn(),
    super.id,
  });

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

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [
        ...super.props,
        useAuthenticator,
        graphQLDelegate,
        restDelegate,
        instanceConfig,
        defaultDelegate,
        signInOptions,
        signIn
      ];

  @override
  Map<String, dynamic> toJson() => _$DataProviderToJson(this);
}

/// [group] and [instance] together define which part **takkan.json** is used to
/// configure a [DataProvider] connection
///
/// Any [group], but typically that used for the main app database, may choose to
/// treat its instances as stages - for example,'dev', 'test', 'qa' and 'prod'.
///
///
///  ------- The rest of this was how it was supposed to be but staging did not work ------------------
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
  NullDataProvider()
      : super(
          signInOptions: const SignInOptions(),
          signIn: const SignIn(),
          instanceConfig: const AppInstance(group: 'none', instance: 'none'),
        );

  factory NullDataProvider.fromJson(Map<String, dynamic> json) =>
      _$NullDataProviderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NullDataProviderToJson(this);
}
