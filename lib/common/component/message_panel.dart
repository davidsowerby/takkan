import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:takkan_client/common/component/key_assist.dart';

/// Not a Toast (use BotToast for that) - this is a widget within the tree structure of the page
class MessagePanel extends StatelessWidget {
  final String message;
  final double width;
  final double height;
  final double elevation;

  const MessagePanel(
      {Key? key, required this.message, this.width = 300, this.height = 160, this.elevation = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    final widthPad = (screenSize.width - width) / 2;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: widthPad, right: widthPad),
      child: Container(
        key: key,
        width: width,
        height: height,
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.primaryColor, width: 3.0),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: elevation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8.0, right: 8, bottom: 24),
                  child: Container(
                    width: width,
                    child: AutoSizeText(message,
                      textKey: keys(key, ['text']),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.4,
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            )),
      ),
    );
  }
}