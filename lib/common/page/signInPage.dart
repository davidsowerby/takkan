import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_script/signin/signIn.dart';

/// This is just used as an interface so that users can define their own implementations through
/// GetIt
abstract class SignInPage extends StatelessWidget {
  DataProvider get dataProvider;

  Map<String, dynamic> get pageArguments;
}

class DefaultSignInPage extends StatelessWidget implements SignInPage {
  final Map<String, dynamic> pageArguments;
  final DataProvider dataProvider;

  const DefaultSignInPage({
    Key? key,
    required this.pageArguments,
    required this.dataProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final PSignInOptions signInOptions=dataProvider.config.signInOptions;
    return Scaffold(
      appBar: AppBar(
        title: Text(signInOptions.pageTitle),
      ),
      body: ListView(
        children: _optionButtons(context,signInOptions),
      ),
    );
  }

  /// TODO: https://gitlab.com/precept1/precept_client/-/issues/30
  List<Widget> _optionButtons(BuildContext context,PSignInOptions signInOptions) {
    final List<Widget> list = List.empty(growable: true);
    if (signInOptions.email) {
      list.add(
        _button(
          'email',
          () => Navigator.pushNamed(
            context,
            'emailSignIn',
            arguments: {'dataProvider': dataProvider},
          ),
        ),
      );
    }
    return list;
  }

  Widget _button(String label, Function() onPressed) {
    return RaisedButton(
      child: Text(label),
      onPressed: onPressed,
    );
  }
}
