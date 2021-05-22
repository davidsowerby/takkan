import 'package:flutter/material.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/library/partLibrary.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

enum DisplayType { text, datePicker }
enum SourceDataType { string, int, timestamp, boolean, singleSelect, textBlock }

/// A [Part] combines field level data with the manner in which it is displayed.  It uses an [EditState]
/// instance (from the widget tree above) to determine whether it is in edit or read mode.
///
/// The default situation (where [singleParticle] is false), uses two particles (just Widgets),
/// one for read mode and one for edit mode.  For example, a Text Widget is used for reading text,
/// and a [TextBox] for edit mode.
///
/// A [readParticle] is always required, and is displayed when in read mode (or the data is static).
/// The [editParticle] is displayed when in edit mode.
/// Both [readParticle] and [editParticle] are constructed by a call to [PartLibrary.partBuilder]
///
/// If [singleParticle] is true, it signifies that particle makes its own modification in response to
/// the current edit state.  In other words, it takes care of its own presentation when in either edit or read mode.
/// The particle is stored in [readParticle]
///
/// [config] is a [PPart] instance, which is contained within a [PScript].
/// [pageArguments] are variable values passed through the page 'url' to the parent [PreceptPage] of this [Part]
/// [parentBinding] is used to maintain a chain back to the data source.
class Part extends StatefulWidget {
  final PPart config;
  final DataBinding parentBinding;
  final Map<String, dynamic> pageArguments;
  final Widget readParticle;
  final Widget? editParticle;
  final bool singleParticle;

  const Part(
      {Key? key,
      this.singleParticle = false,
      required this.config,
      this.editParticle,
      required this.readParticle,
      required this.pageArguments,
      this.parentBinding = const NoDataBinding()})
      : super(key: key);

  @override
  PartState createState() => PartState(config, parentBinding, pageArguments);
}

class PartState extends ContentState<Part, PPart> {
  PartState(PPart config, DataBinding parentBinding, Map<String, dynamic> pageArguments)
      : super(
          config,
          parentBinding,
          pageArguments,
        );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return doBuild(context, theme, dataSource, widget.config, widget.pageArguments);
  }

  @override
  Widget assembleContent(ThemeData theme) {
    if (widget.singleParticle) return widget.readParticle;

    if (config.isStatic == IsStatic.yes || widget.config.readOnly) {
      return widget.readParticle;
    }
    final EditState editState = Provider.of<EditState>(context);
    if (widget.editParticle != null) {
      return (editState.readMode) ? widget.readParticle : widget.editParticle!;
    } else {throw PreceptException('EditParticle must not be null at this point');}
  }

  @override
  Widget layout({required List<Widget> children,required  Size screenSize,required  PPart config}) {
    // TODO: implement layout
    throw UnimplementedError();
  }

  @override
  bool get preloaded => false;
}
