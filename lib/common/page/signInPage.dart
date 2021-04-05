import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_script/signin/signIn.dart';

/// This is just used as an interface so that users can define their own implementations through
/// GetIt
abstract class SignInPage extends StatelessWidget {
  PSignInOptions get signInOptions;
}

class DefaultSignInPage extends StatelessWidget implements SignInPage {
  final PSignInOptions signInOptions;

  const DefaultSignInPage({Key key, @required this.signInOptions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(signInOptions.pageTitle),
      ),
      body: ListView(
        children: _optionButtons(context),
      ),
    );
  }

  /// TODO: https://gitlab.com/precept1/precept_client/-/issues/30
  List<Widget> _optionButtons(BuildContext context) {
    final List<Widget> list=List();
    if (signInOptions.email) {
      list.add( _button('email',()=> Navigator.pushNamed(context, 'emailSignIn')));
    }
    return list;
  }

  Widget _button(String label, Function() onPressed){
    return RaisedButton(child: Text(label), onPressed: onPressed,);
  }
}
