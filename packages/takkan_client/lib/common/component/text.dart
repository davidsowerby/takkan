import 'package:flutter/widgets.dart';

/// Simply a [Text] set up to wrap
class TextBlock extends StatelessWidget {
  final String text;
  final TextStyle style;

  const TextBlock(
      {Key? key, required this.text, this.style = const TextStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(text, style: style),
          ),
        ],
      ),
    );
  }
}
