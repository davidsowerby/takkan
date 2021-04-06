import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/panel/panelStyle.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/trait/textTrait.dart';
import 'package:precept_script/validation/message.dart';


/// [listEntryConfig] is only relevant if this content represents a list, and describes how the list entry
/// should be displayed.  This can be any [PPanel] implementation, but is usually [PNavTile] or [PListTile]
class PContent extends PCommon {
  final String caption;
  final String property;
  final PPanel listEntryConfig;

  PContent({
    this.caption,
    this.property,
    this.listEntryConfig,
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle = const PPanelStyle(),
    PTextTrait textTrait,
    ControlEdit controlEdit = ControlEdit.inherited,
    PSchema schema,
    String id,
  }) : super(
    query: query,
    schema: schema,
    id: id,
    controlEdit: controlEdit,
    panelStyle: panelStyle,
    textTrait: textTrait,
    dataProvider: dataProvider,
    isStatic: isStatic,
  );
}

/// Common abstraction for [PPanel] and [PPart] so both can be held in any order for display
/// Separated from [PContent], because a page cannot contain a page
///
/// However, it does not really make sense for a [PPart] to define a [dataProvider] or [query],
/// and are therefore unused by a [PPart]
class PSubContent extends PContent {
  PSubContent({
    String caption,
    String property,
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle=const PPanelStyle(),
    PTextTrait textTrait,
    ControlEdit controlEdit = ControlEdit.inherited,
    String id,
  }) : super(
    caption: caption,
    property: property,
    isStatic: isStatic,
    dataProvider: dataProvider,
    query: query,
    panelStyle: panelStyle,
    textTrait: textTrait,
    controlEdit: controlEdit,
    id: id,
  );

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (isStatic != IsStatic.yes) {
      if (property == null) {
        messages.add(
          ValidationMessage(
            item: this,
            msg: 'is not static, and must therefore declare a property (which can be an empty String)',
          ),
        );
      }
      if (!hasEditControl && !(inheritedEditControl)) {
        messages.add(
          ValidationMessage(
            item: this,
            msg: 'is not static, but there is no editControl set in this or its parent chain',
          ),
        );
      }
      if (query == null) {
        messages.add(
          ValidationMessage(
            item: this,
            msg: "must either be static or have a query defined",
          ),
        );
      }

    }
    if (query != null) {
      if (dataProvider == null) {
        messages.add(
          ValidationMessage(
            item: this,
            msg: 'has declared a data source, but it must have a dataProvider available as well',
          ),
        );
      }
    }

  }

  @override
  String get idAlternative => caption;
}
