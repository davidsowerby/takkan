import 'package:meta/meta.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:precept_back4app_client/backend/back4app/provider/data_provider.dart';
import 'package:precept_back4app_client/backend/back4app/provider/pback4app_data_provider.dart';
import 'package:precept_backend/backend/user/authenticator.dart';
import 'package:precept_backend/backend/user/precept_user.dart';
import 'package:precept_script/query/query.dart';

class Back4AppAuthenticator extends Authenticator<PBack4AppDataProvider,
    ParseUser, Back4AppDataProvider> {
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
      final updatedUser = preceptUserFromNative(nativeUser);
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      return AuthenticationResult(
        success: false,
        message: authResult.error?.message ?? 'Unknown',
        user: PreceptUser.unknownUser(),
        errorCode: authResult.error?.code ?? -999,
      );
    }
  }

  Future<void> doSignOut() async {
    await nativeUser?.logout();
  }

  @override
  Future<bool> doDeRegister(PreceptUser user) {
    // TODO: implement doDeRegister
    throw UnimplementedError();
  }

  // TODO: should not allow call if already logged in (_parseUser would be overwritten)
  @override
  Future<AuthenticationResult> doRegisterWithEmail(
      {required String username, required String password}) async {
    final nativeUser = ParseUser(username, password, username);
    final ParseResponse authResult = await nativeUser.signUp();
    final updatedUser = preceptUserFromNative(nativeUser);
    this.nativeUser = nativeUser;
    if (authResult.success) {
      return AuthenticationResult(success: true, user: updatedUser);
    } else {
      final errorCode = authResult.error?.code ?? -999;
      if (errorCode == 101) {
        return AuthenticationResult(
            success: false, errorCode: -1, user: PreceptUser.unknownUser());
      }
      return AuthenticationResult(
          success: false,
          message: authResult.error?.message ?? 'Unknown',
          user: PreceptUser.unknownUser());
    }
  }

  @override
  Future<bool> doRequestPasswordReset(PreceptUser user) async {
    final nativeUser = preceptUserToNative(user);
    final result = await nativeUser.requestPasswordReset();
    this.nativeUser = nativeUser;
    return result.success;
  }

  @override
  Future<bool> doUpdateUser(PreceptUser user) {
    // TODO: implement doUpdateUser
    throw UnimplementedError();
  }

  @override
  PreceptUser preceptUserFromNative(ParseUser? nativeUser) {
    if (nativeUser == null) {
      return PreceptUser.unknownUser();
    }
    // ignore: invalid_use_of_protected_member
    final Map<String, dynamic> json = nativeUser.toJson();
    return PreceptUser.fromJson(json);
  }

  @override
  ParseUser preceptUserToNative(PreceptUser preceptUser) {
    return ParseUser(preceptUser.userName, '?', preceptUser.email);
  }

  @override
  Future<List<String>> loadUserRoles() async {
    PGraphQLQuery query = PGraphQLQuery(
      queryName: 'userRoles',
      script: userRolesScript,
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
