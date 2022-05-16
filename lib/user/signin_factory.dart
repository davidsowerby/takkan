import 'package:takkan_client/page/signin_page.dart';
import 'package:takkan_client/user/email_signin_page.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';

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
