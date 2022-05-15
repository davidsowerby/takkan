import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_client/page/signin_page.dart';
import 'package:precept_client/user/email_signin_page.dart';

abstract class SignInFactory {
  SignInPage signInPage({
    required Map<String, dynamic> pageArguments,
    required IDataProvider dataProvider,
  });
}

class DefaultSignInFactory implements SignInFactory {
  @override
  SignInPage signInPage({
    required Map<String, dynamic> pageArguments,
    required IDataProvider dataProvider,
  }) {
    return DefaultSignInPage(pageArguments: pageArguments, dataProvider: dataProvider);
  }
}

abstract class EmailSignInFactory {
  EmailSignInPage emailSignInPage({
    required IDataProvider dataProvider,
    required String successRoute,
    required String failureRoute,
    required Map<String, dynamic> pageArguments,
  });
}

class DefaultEmailSignInFactory implements EmailSignInFactory {
  @override
  EmailSignInPage emailSignInPage({
    required IDataProvider dataProvider,
    required String successRoute,
    required String failureRoute,
    required Map<String, dynamic> pageArguments,
  }) {
    return EmailSignInPage(
      successRoute: successRoute,
      failureRoute: failureRoute,
      pageArguments: pageArguments,
      dataProvider: dataProvider,
    );
  }
}
