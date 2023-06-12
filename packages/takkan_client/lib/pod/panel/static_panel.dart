import 'package:flutter/material.dart';
import 'package:takkan_client/data/data_source.dart';

/// A panel which displays only static data, and therefore requires no connections to
/// dynamic data.
///
/// It does, however, contain a [parentDataContext], which allows a [StaticPanel]
/// to be in the chain of [DataContext] instances, without breaking it, even though
/// it does not actually use the data.
///
/// Built by [panelBuilder]
class StaticPanel extends StatelessWidget {
  final DataContext parentDataContext;
  final Widget content;

  const StaticPanel({
    Key? key,
    required this.parentDataContext,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
