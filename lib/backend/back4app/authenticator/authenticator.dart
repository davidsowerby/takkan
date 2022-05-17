import 'package:meta/meta.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:takkan_back4app_client/backend/back4app/provider/data_provider.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/select/query.dart';

class Back4AppAuthenticator
    extends Authenticator<DataProvider, ParseUser, Back4AppDataProvider> {
  late Parse parse;
  late Back4AppDataProvider parent;

  Back4AppAuthenticator();

  init(Back4AppDataProvider parent) async {
    this.parent = parent;
    parse = await Parse().initialize(
      parent.instanceConfig.appId,
      parent.instanceConfig.serverUrl,
      clientKey: parent.instanceConfig.clientKey,
    );
    status = SignInStatus.Initialised;
  }

// TODO: should not allow call if already logged in (_parseUser would be overwritten)
  /// Username defaults to email address
  @protected
  Future<AuthenticationResult> doSignInByEmail(
      {required String username, required String password}) async {
    final nativeUser = ParseUser(username, password, username);
    nativeUser.password = password;
    this.nativeUser = nativeUser;
    final ParseResponse authResult = await nativeUser.login();
    if (authResult.success) {
      final updatedUser = takkanUserFromNative(nativeUser);
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      return AuthenticationResult(
        success: false,
        message: authResult.error?.message ?? 'Unknown',
        user: TakkanUser.unknownUser(),
        errorCode: authResult.error?.code ?? -999,
      );
    }
  }

  Future<void> doSignOut() async {
    await nativeUser?.logout();
  }

  @override
  Future<bool> doDeRegister(TakkanUser user) {
    // TODO: implement doDeRegister
    throw UnimplementedError();
  }

  // TODO: should not allow call if already logged in (_parseUser would be overwritten)
  @override
  Future<AuthenticationResult> doRegisterWithEmail(
      {required String username, required String password}) async {
    final nativeUser = ParseUser(username, password, username);
    final ParseResponse authResult = await nativeUser.signUp();
    final updatedUser = takkanUserFromNative(nativeUser);
    this.nativeUser = nativeUser;
    if (authResult.success) {
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      final errorCode = authResult.error?.code ?? -999;
      if (errorCode == 101) {
        return AuthenticationResult(
            success: false, errorCode: -1, user: TakkanUser.unknownUser());
      }
      return AuthenticationResult(
          success: false,
          message: authResult.error?.message ?? 'Unknown',
          user: TakkanUser.unknownUser());
    }
  }

  @override
  Future<bool> doRequestPasswordReset(TakkanUser user) async {
    final nativeUser = takkanUserToNative(user);
    final result = await nativeUser.requestPasswordReset();
    this.nativeUser = nativeUser;
    return result.success;
  }

  @override
  Future<bool> doUpdateUser(TakkanUser user) {
    // TODO: implement doUpdateUser
    throw UnimplementedError();
  }

  @override
  TakkanUser takkanUserFromNative(ParseUser? nativeUser) {
    if (nativeUser == null) {
      return TakkanUser.unknownUser();
    }
    // ignore: invalid_use_of_protected_member
    final Map<String, dynamic> json = nativeUser.toJson();
    return TakkanUser.fromJson(json);
  }

  @override
  ParseUser takkanUserToNative(TakkanUser takkanUser) {
    return ParseUser(takkanUser.userName, '?', takkanUser.email);
  }

  @override
  Future<List<String>> loadUserRoles() async {
    GraphQLQuery query = GraphQLQuery(
      queryName: 'userRoles',
      queryScript: userRolesScript,
      returnType: QueryReturnType.futureList,
      variables: {'id': user.objectId},
      documentSchema: '_Role',
    );
    final loadResult =
        await parent.fetchList(queryConfig: query, pageArguments: const {});
    final List<Map<String, dynamic>> result = loadResult.data;
    final List<String> roles = List.empty(growable: true);
    result.forEach((element) {
      roles.add(element['name']);
    });
    return roles;
  }
}

final userRolesScript = r'''query GetRoles  ($id: ID!) {
  roles (where: {users: {have: {id:{equalTo: $id}}}}){
    edges {
    node{name}
    }
    }

}''';
