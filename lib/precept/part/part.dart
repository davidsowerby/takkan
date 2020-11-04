import 'package:flutter/material.dart';
import 'package:precept/common/logger.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

enum DisplayType { text, datePicker }
enum SourceDataType { string, int, timestamp, boolean, singleSelect, textBlock }

/// A [Part] brings together data at the field level, with the manner in which it is displayed.
///
/// [Part] implementations are builders that display a read only or editable Widget.  The Widget displayed
/// depends on the [SourceDataType], edit mode, and display option.
///
/// The source data type goes beyond the raw data types typically provided by a backend such as Firestore or Parse Server.
/// It also takes into account how the data is used.
///
/// For example, a String may be just that, or it may be the currently selected value from a set of options.
///
/// - There is, therefore, a [StringPart] and a [StringSingleSelectPart] to cater for both situations.
/// - The [StringPart] just processes strings from the database and displays them as a [Text] in read only,
/// and a [TextField] in edit mode.
/// - A [StringSingleSelectPart] still handles a string, but for an item which is a single choice from a list of options.
/// Its displayOption can be RadioButton or Combo
///
/// An instance of [Binding] is used to transfer data from a [TemporaryDocument]
///
/// A caption may optionally be displayed in either read only or edit mode.
///
abstract class Part extends StatelessWidget {
  final PPart precept;

  const Part({@required this.precept}) : super();

  @override
  Widget build(BuildContext context) {
    final SectionState sectionState =
        Provider.of<SectionState>(context);
    final readOnly = precept.readOnly || sectionState.readOnlyMode;
    getLogger(this.runtimeType).d(
        "caption: ${precept.caption}, EditState readOnly: ${precept.readOnly}");
    if (readOnly) {
      return buildReadOnlyWidget(context);
    } else {
      return buildEditModeWidget(context);
    }
  }

  Widget buildReadOnlyWidget(BuildContext context);

  Widget buildEditModeWidget(BuildContext context);
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
