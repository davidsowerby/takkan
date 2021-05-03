import 'package:flutter/material.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/library/particleLibrary.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/page/standardPage.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

enum DisplayType { text, datePicker }
enum SourceDataType { string, int, timestamp, boolean, singleSelect, textBlock }

/// A [Part] combines field level data with the manner in which it is displayed.  It uses an [EditState]
/// instance (from the widget tree above) to determine whether it is in edit or read mode.
///
/// A [readParticle] is required, and is displayed when in read mode (or the data is static).one for reading data and one for editing data.
/// The [editParticle] is displayed when in edit mode.
/// Both [readParticle] and [editParticle] are constructed by a call to [ParticleLibrary.partBuilder]
/// [config] is a [PPart] instance, which is contained within a [PScript].
/// [pageArguments] are variable values passed through the page 'url' to the parent [PreceptPage] of this [Part]
/// [parentBinding] is used to maintain a chain back to the data source.
class Part extends StatefulWidget {
  final PPart config;
  final DataBinding parentBinding;
  final Map<String, dynamic> pageArguments;
  final Widget readParticle;
  final Widget editParticle;

  const Part(
      {Key key,
      @required this.config,
      this.editParticle,
      this.readParticle,
      this.pageArguments,
      this.parentBinding = const NoDataBinding()})
      : super(key: key);

  @override
  PartState createState() => PartState(config, parentBinding);
}

class PartState extends ContentState<Part, PPart> {
  PartState(PPart config, DataBinding parentBinding) : super(config, parentBinding);

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
    if (config.isStatic==IsStatic.yes || widget.config.readOnly){
      return widget.readParticle;
    }
    final EditState editState = Provider.of<EditState>(context);
    assert(widget.editParticle!=null);
    return (editState.readMode) ? widget.readParticle : widget.editParticle;
  }

  @override
  Widget layout({List<Widget> children, Size screenSize, PPart config}) {
    // TODO: implement layout
    throw UnimplementedError();
  }

}
