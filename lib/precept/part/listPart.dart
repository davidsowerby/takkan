//import 'package:flutter/material.dart';
//import 'package:kayman/common/data/binding/binding.dart';
//import 'package:kayman/common/data/binding/listBinding.dart';
//import 'package:kayman/common/property/part.dart';
//import 'package:kayman/common/property/tablePart.dart';
//import 'package:kayman/common/scrollingTable.dart';
//
//class ListPart extends Part {
//  final double width;
//  final double height;
//  final String columnCaption;
//  final PrimitivePart columnProperty;
//  final Alignment columnAlignment;
//  final bool stripedRows;
//  final double rowHeightReadOnly;
//  final double rowHeightEditMode;
//
//  const ListPart({
//    Key key,
//                       bool readOnly,
//    ListBinding binding,
//    String caption,
//    IconData icon,
//                       this.rowHeightEditMode = 80,
//                       this.rowHeightReadOnly = 40,
//    this.columnAlignment = Alignment.topLeft,
//    this.columnCaption,
//    this.columnProperty,
//    this.width = 300,
//    this.height = 500,
//    this.stripedRows = true,
//    EdgeInsets padding = const EdgeInsets.only(bottom: 8.0),
//    ListReadOnly readOnlyOptions = const ListReadOnly(),
//    ListEditMode editModeOptions = const ListEditMode(),
//  }) : super(
//          binding: binding,
//    key: key,
//          caption: caption,
//          icon: icon,
//          padding: padding,
//          readOnlyOptions: readOnlyOptions,
//          editModeOptions: editModeOptions,
//        );
//
//  Widget readOnlyWidget(BuildContext context, ThemeData theme) {
//    return ScrollingTable(
//      isList: true,
//      rowHeightReadOnly: rowHeightReadOnly,
//      rowHeightEditMode: rowHeightEditMode,
//      binding: binding,
//      columnProperties: [columnProperty],
//      height: height,
//      caption: caption,
//      columnPropertyNames: [],
//      width: width,
//      stripedRows: stripedRows,
//      columnAlignments: {},
//      columnCaptions: [caption],
//      columnWidths: [1],
//      defaultColumnAlignment: columnAlignment,
//    );
//  }
//
//  /// A [TablePart] is always read only in itself - editing of content is through its [columnProperties]
//  @override
//  Widget editModeWidget(BuildContext context, ThemeData theme) {
//    return readOnlyWidget(context, theme);
//  }
//}
//
//class ListEditMode extends EditMode {
//  const ListEditMode({bool showCaption = true, bool showColumnHeading = false})
//      : super(showCaption: showCaption, showColumnHeading: showColumnHeading);
//}
//
//class ListReadOnly extends ReadOnly {
//  const ListReadOnly({
//    bool showCaption = true,
//    bool showColumnHeading = false,
//    TextStyle style,
//  }) : super(showCaption: showCaption, style: style, showColumnHeading: showColumnHeading);
//}
