import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/document/document.dart';
import 'package:precept_client/precept/document/documentState.dart';
import 'package:precept_client/precept/library/pageLibrary.dart';
import 'package:precept_client/precept/model/element.dart';
import 'package:precept_client/precept/model/error.dart';
import 'package:precept_client/precept/model/model.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:precept_client/section/base/section.dart';
import 'package:precept_client/section/base/sectionState.dart';
import 'package:provider/provider.dart';

class PageBuilder {
  const PageBuilder();

  /// Assembles Widgets from [elements]
  /// [baseBinding] is the data binding for the level of the caller.  [Part]s and [Section]s
  /// attach themselves to that binding.  May be null, when called by a Page (because a document is held at [Document] level,
  /// or where a Widget only contains static text / content and therefore does not require a data binding
  List<Widget> assembleElements({@required List<DisplayElement> elements, MapBinding baseBinding}) {
    final list = List<Widget>();
    for (var element in elements) {
      switch (element.runtimeType) {
        case PString:
          assert(baseBinding != null);
          list.add(StringPart(
            pPart: element,
            baseBinding: baseBinding,
          ));
          break;
        case PSection:
          list.add(constructSection(pSection: element, baseBinding: baseBinding));
          break;
        case PStaticText:
          final PStaticText config = element;
          list.add(AutoSizeText(
            config.text,
            softWrap: config.softWrap,
          ));
          break;
        default:
          final message = "Assembler not defined for ${element.runtimeType}";
          getLogger(this.runtimeType).e(message);
          throw PreceptException(message);
      }
    }
    return list;
  }

  /// Visible for testing
  Widget constructDocument({@required PDocument pDocument}) {
    return ChangeNotifierProvider<DocumentState>(
        create: (_) => DocumentState(config: pDocument), child: Document(config: pDocument));
  }

  /// Visible for testing
  /// If [pSection] does not specify a property, [baseBinding] is passed through to the [Section]
  /// If [pSection] does specify a property, that property is used to create a new 'child' [ModelBinding] for the section
  Widget constructSection({@required PSection pSection, @required ModelBinding baseBinding}) {
    return ChangeNotifierProvider<SectionState>(
        create: (_) => SectionState(readOnlyMode: false, canEdit: true),
        child: Section(
          config: pSection,
          baseBinding: (pSection.property == null)
              ? baseBinding
              : baseBinding.modelBinding(property: pSection.property),
        ));
  }

  /// Visible for testing
// Widget constructSection(
//     {@required PSection section}) {
//   return ChangeNotifierProvider<SectionState>(
//       create: (_) => SectionState(readOnlyMode: false, canEdit: true),
//       child: Section(config: section));
// }

  /// Returns the Widget representing page [route.page.pageKey], configured with [route.page]
  /// If there is no matching key in the [PageLibrary], an error page is returned.
  Widget buildRoute({@required PRoute route}) {
    final page = pageLibrary.find(route.page.pageKey, route.page);
    return (page == null)
        ? pageLibrary.errorPage(PError(
            message:
                "Page ${route.page.pageKey}, has not been defined but was requested by route: ${route.path}")) // TODO message should come from Precept
        : page;
  }

  Widget routeNotRecognised(RouteSettings settings) {
    return pageLibrary.errorPage(PError(
        message:
            "Route not recognised: ${settings.name}")); // TODO message should come from Precept
  }
}
