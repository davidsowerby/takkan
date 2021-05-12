import 'package:flutter/foundation.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_client/common/page/signInPage.dart';
import 'package:precept_client/user/emailSignInPage.dart';
import 'package:precept_script/signin/signIn.dart';

abstract class SignInFactory {
  SignInPage signInPage({
    @required PSignInOptions options,
    @required Map<String, dynamic> pageArguments,
    @required DataProvider dataProvider,
  });
}

class DefaultSignInFactory implements SignInFactory {
  @override
  SignInPage signInPage({
    @required PSignInOptions options,
    @required Map<String, dynamic> pageArguments,
    @required DataProvider dataProvider,
  }) {
    return DefaultSignInPage(signInOptions: options, pageArguments: pageArguments, dataProvider:dataProvider);
  }
}

abstract class EmailSignInFactory {
  EmailSignInPage emailSignInPage({
    DataProvider dataProvider,
    String successRoute,
    String failureRoute,
    @required Map<String, dynamic> pageArguments,
  });
}

class DefaultEmailSignInFactory implements EmailSignInFactory {
  @override
  EmailSignInPage emailSignInPage({
    @required DataProvider dataProvider,
    @required String successRoute,
    @required String failureRoute,
    @required Map<String, dynamic> pageArguments,
  }) {
    return EmailSignInPage(
      successRoute: successRoute,
      failureRoute: failureRoute,
      pageArguments: pageArguments,
      dataProvider: dataProvider,
    );
  }
}
