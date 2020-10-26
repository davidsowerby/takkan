//import 'package:flutter/material.dart';
//import 'package:kayman/common/data/binding/binding.dart';
//import 'package:kayman/common/data/binding/listBinding.dart';
//import 'package:kayman/common/property/part.dart';
//import 'package:kayman/common/scrollingTable.dart';
//
//class TablePart extends Part {
//  final double width;
//  final double height;
//  final List<int> columnWidths;
//  final List<String> columnCaptions;
//  final List<String> columnPropertyNames;
//  final List<PrimitivePart> columnProperties;
//  final Map<int, Alignment> columnAlignments;
//  final Alignment defaultColumnAlignment;
//  final bool stripedRows;
//  final bool showEditIcon;
//  final double rowHeightReadOnly;
//  final double rowHeightEditMode;
//
//  const TablePart({
//                        Key key,
//                        ListBinding binding,
//                        String caption,
//                        IconData icon,
//                        this.width = 300,
//                        this.height = 500,
//                        this.rowHeightEditMode = 80,
//                        this.rowHeightReadOnly = 40,
//                        this.showEditIcon = true,
//                        this.stripedRows = true,
//                        this.columnWidths,
//                        this.columnPropertyNames,
//                        this.columnProperties,
//                        this.columnAlignments = const {},
//                        this.defaultColumnAlignment = Alignment.center,
//                        @required this.columnCaptions,
//                        EdgeInsets padding = const EdgeInsets.only(bottom: 8.0),
//                        TableReadOnly readOnlyOptions = const TableReadOnly(),
//                        TableEditMode editModeOptions = const TableEditMode(),
//                      }) : super(
//    key: key,
//    binding: binding,
//    caption: caption,
//    icon: icon,
//    padding: padding,
//    readOnlyOptions: readOnlyOptions,
//    editModeOptions: editModeOptions,
//    );
//
//  /// A [TablePart] is always read only in itself - editing of content is through its [columnProperties]
//  @override
//  Widget editModeWidget(BuildContext context, ThemeData theme) {
//    return readOnlyWidget(context, theme);
//  }
//
//  @override
//  Widget readOnlyWidget(BuildContext context, ThemeData theme) {
//    return ScrollingTable(
//      isList: false,
//      rowHeightReadOnly: rowHeightReadOnly,
//      rowHeightEditMode: rowHeightEditMode,
//      binding: binding,
//      columnProperties: columnProperties,
//      height: height,
//      caption: caption,
//      columnPropertyNames: columnPropertyNames,
//      width: width,
//      stripedRows: stripedRows,
//      columnAlignments: columnAlignments,
//      columnCaptions: columnCaptions,
//      columnWidths: columnWidths,
//      defaultColumnAlignment: defaultColumnAlignment,
//      );
//  }
//}
//
//class TableEditMode extends EditMode {
//  const TableEditMode({bool showCaption = true}) : super(showCaption: showCaption);
//}
//
//class TableReadOnly extends ReadOnly {
//  const TableReadOnly({
//                        bool showCaption = true,
//                        TextStyle style,
//                      }) : super(showCaption: showCaption, style: style);
//}
