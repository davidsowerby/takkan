import 'package:flutter/material.dart';
import 'package:precept/common/editState/sectionEditState.dart';
import 'package:precept/common/logger.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:provider/provider.dart';

enum DisplayType { text, datePicker }
enum SourceDataType { string, int, timestamp, boolean, singleSelect, textBlock }

/// The [Part] series display data from the database of types.
///
/// [Part] implementations are effectively builders that display a read only or editable Widget.  The Widget displayed
/// depends on the [SourceDataType], edit mode, and display option.
///
/// The source data type goes beyond the raw data types typically provided by a backend such as Firestore or Parse Server.
/// It also takes into account how the data is used.
/// For example, a String may be just that, or it may be the currently selected value from a set of options.
///
/// There is, therefore, a [StringPart] and a [StringSingleSelectPart] to cater for both situations.
///
/// The [StringPart] just processes strings from the database and displays them as a [Text] in read only,
/// and a [TextField] in edit mode.
///
/// A [StringSingleSelectPart] still handles a string, but for an item which is a single choice from a list of options.
/// Its displayOption can be RadioButton or Combo
///
/// An instance of [Binding] is used to transfer data from an associated Model
///
/// A caption may optionally be displayed in either read only or edit mode.
///
/// [T] the type of data read from the database
abstract class Part<T, READONLY extends ReadOnlyOptions,
    EDITMODE extends EditModeOptions> extends StatelessWidget {
  final Binding<T> binding;
  final String caption;
  final IconData icon;
  final EdgeInsets padding;
  final EDITMODE editModeOptions;
  final READONLY readOnlyOptions;
  final SourceDataType sourceDataType;

  const Part({
    Key key,
    @required this.sourceDataType,
    this.binding,
    this.padding = const EdgeInsets.only(bottom: 8.0),
    this.caption,
    this.icon,
    this.editModeOptions,
    this.readOnlyOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SectionEditState sectionEditState =
        Provider.of<SectionEditState>(context);
    final readOnly = sectionEditState.readMode;
    getLogger(this.runtimeType)
        .d("caption: $caption, EditState readOnly: $readOnly");
    if (readOnly) {
      return readOnlyWidget(context: context);
    } else {
      return editModeWidget(context: context);
    }
  }

  /// looks up the edit state of the parent document or table.  This allows column properties within a table to correctly
  /// reflect edit state while the table is in focus, witout changes to it reflecting back into the document edit state
//  bool getEditStatus(BuildContext context) {
//    final editState = Provider.of<DocumentEditState>(context);
//    if (editState.hasTableInFocus) {
//      return editState.tableReadOnly;
//    } else {
//      return editState.readOnly;
//    }
//  }

  Widget buildReadOnlyWidget(BuildContext context);

  Widget buildEditModeWidget(BuildContext context);

  Widget readOnlyWidget({BuildContext context}) {
    return buildReadOnlyWidget(context);
  }

  Widget editModeWidget({BuildContext context}) {
    return buildEditModeWidget(context);
  }
}

/// Common base class for part specific read only options which support [Part]
class ReadOnlyOptions {
  final bool showCaption;
  final bool showColumnHeading;
  final TextStyle style;

  const ReadOnlyOptions(
      {this.showCaption = true,
      this.style = const TextStyle(),
      this.showColumnHeading = true});
}

/// Common base class for edit mode options which support [Part]
class EditModeOptions {
  final bool showCaption;
  final bool showColumnHeading;

  const EditModeOptions(
      {this.showCaption = true, this.showColumnHeading = true});
}

class TrueFunction {
  const TrueFunction();

  bool call() {
    return true;
  }
}
