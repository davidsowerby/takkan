import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_client/common/page/signInPage.dart';
import 'package:precept_client/user/emailSignInPage.dart';

abstract class SignInFactory {
  SignInPage signInPage({
    required Map<String, dynamic> pageArguments,
    required DataProvider dataProvider,
  });
}

class DefaultSignInFactory implements SignInFactory {
  @override
  SignInPage signInPage({
    required Map<String, dynamic> pageArguments,
    required DataProvider dataProvider,
  }) {
    return DefaultSignInPage(pageArguments: pageArguments, dataProvider: dataProvider);
  }
}

abstract class EmailSignInFactory {
  EmailSignInPage emailSignInPage({
    required DataProvider dataProvider,
    required String successRoute,
    required String failureRoute,
    required Map<String, dynamic> pageArguments,
  });
}

class DefaultEmailSignInFactory implements EmailSignInFactory {
  @override
  EmailSignInPage emailSignInPage({
    required DataProvider dataProvider,
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
