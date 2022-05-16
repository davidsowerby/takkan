import 'package:flutter/material.dart';
import 'package:takkan_client/app/router.dart';
import 'package:takkan_client/common/component/key_assist.dart';
import 'package:takkan_client/common/component/message_panel.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/trait/text.dart';
import 'package:takkan_client/trait/trait_library.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/part/text.dart' as TextConfig;
import 'package:takkan_script/signin/sign_in.dart';

class EmailSignInWidget extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final EmailSignIn config;
  final DataContext dataContext;

  EmailSignInWidget(
      {super.key, required this.config, required this.dataContext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = dataContext.dataProvider;
    final status = provider.authenticator.status;
    switch (status) {
      case SignInStatus.Authenticating:
        return Center(
            child: MessagePanel(message: config.checkingCredentialsMessage));
      case SignInStatus.Uninitialized:
      case SignInStatus.Initialised:
      case SignInStatus.Unauthenticated:
      case SignInStatus.Authentication_Failed:
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: keys(key, ['emailField']),
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: config.emailCaption,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: keys(key, ['usernameField']),
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.supervised_user_circle),
                    labelText: config.usernameCaption,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: keys(key, ['passwordField']),
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.security),
                    labelText: config.passwordCaption,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (status == SignInStatus.Authentication_Failed) failureMessage(theme),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    child: Text(config.submitCaption),
                    onPressed: () => submitCredentials(context, dataContext)),
              )
            ],
          ),
        );
      case SignInStatus.Authenticated:
        return Center(child: MessagePanel(message: 'Successful'));
      case SignInStatus.Removing_Registration:
      case SignInStatus.Reset_Requested:
      case SignInStatus.Registering:
      case SignInStatus.Registered:
      case SignInStatus.Registration_Failed:
      case SignInStatus.Registration_Removed:
      case SignInStatus.User_Not_Known:
        throw TakkanException(
            'Should not be here ...  should have gone to another route');
    }
  }

  /// Submits credentials for email log in, and navigate to the next route.
  /// The next route is determined by:
  ///
  /// - [config.successRoute] if it is not empty
  /// - If [config.successRoute] is empty, navigate to page user was going to before interrupted by sign in,
  /// held by [router.preSignInRoute]
  /// - If [router.preSignInRoute] is null, default to '/'
  submitCredentials(BuildContext context, DataContext dataConnector) async {
    final provider = dataConnector.dataProvider;
    AuthenticationResult result = await provider.authenticator.signInByEmail(
      username: emailController.text,
      password: passwordController.text,
    );
    if (result.success) {
      /// Remove the sign in pages from Navigator history
      Navigator.of(context).popUntil(_notSignInRoute);

      /// And also the incomplete page caused by jumping off to sign in
      Navigator.of(context).pop();
      final nextRoute = (config.successRoute == '')
          ? (router.preSignInRoute == null)
          ? '/'
          : router.preSignInRoute
          : config.successRoute;
      Navigator.of(context).pushNamed(nextRoute!);
    } else {
      logType(this.runtimeType).d("login unsuccessful");
    }
  }

  bool _notSignInRoute(Route route) {
    String? routePath = route.settings.name;
    return (routePath == null) ? true : !routePath.toLowerCase().contains('signin');
  }

  Widget failureMessage(ThemeData theme ){
    final TextTrait trait = traitLibrary.findParticleTrait(
        theme: theme, traitName: TextConfig.Text.errorText) as TextTrait;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        config.signInFailureMessage,
        style: trait.textStyle,
        textAlign: trait.textAlign,
      ),
    );
  }
}
