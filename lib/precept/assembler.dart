import 'package:flutter/widgets.dart';
import 'package:precept_client/assembler/pageAssembler.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:precept_client/precept/script/element.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:precept_client/section/base/section.dart';



  /// Assembles Widgets from [elements]
  /// [baseBinding] is the data binding for the level of the caller.  [Part]s and [Section]s
  /// attach themselves to that binding.  May be null, when called by a Page (because a document is held at [Panel] level,
  /// or where a Widget only contains static text / content and therefore does not require a data binding
  List<Widget> assembleElements({@required List<DisplayElement> elements, MapBinding baseBinding, bool isStatic}) {
    final list = List<Widget>();
    for (var element in elements) {
      switch (element.runtimeType) {
        case PString:
          assert(baseBinding != null);
          list.add(StringPart(
            isStatic: isStatic,
            pPart: element,
            baseBinding: baseBinding,
          ));
          break;
        case PPanel:
          list.add(constructSection(pSection: element, baseBinding: baseBinding, isStatic:isStatic));
          break;

        default:
          final message = "Assembler not defined for ${element.runtimeType}";
          logName('assembleElements').e(message);
          throw PreceptException(message);
      }
    }
    return list;
  }


