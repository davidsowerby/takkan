// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PScript _$PScriptFromJson(Map<String, dynamic> json) {
  return PScript(
    conversionErrorMessages: ConversionErrorMessages.fromJson(
        json['conversionErrorMessages'] as Map<String, dynamic>),
    routes: (json['routes'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, PRoute.fromJson(e as Map<String, dynamic>)),
    ),
    name: json['name'] as String,
    authenticator: json['authenticator'] == null
        ? null
        : PAuthenticator.fromJson(
            json['authenticator'] as Map<String, dynamic>),
    isStatic: _$enumDecode(_$IsStaticEnumMap, json['isStatic']),
    dataProvider: PDataProviderConverter.fromJson(
        json['dataProvider'] as Map<String, dynamic>),
    dataSource: PDataSourceConverter.fromJson(
        json['dataSource'] as Map<String, dynamic>),
    panelStyle: json['panelStyle'] == null
        ? null
        : PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle: json['writingStyle'] == null
        ? null
        : WritingStyle.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$PScriptToJson(PScript instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'panelStyle': instance.panelStyle?.toJson(),
    'writingStyle': instance.writingStyle?.toJson(),
    'name': instance.name,
    'authenticator': instance.authenticator?.toJson(),
    'routes': instance.routes.map((k, e) => MapEntry(k, e.toJson())),
    'conversionErrorMessages': instance.conversionErrorMessages.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'dataProvider', PDataProviderConverter.toJson(instance.dataProvider));
  writeNotNull('dataSource', PDataSourceConverter.toJson(instance.dataSource));
  val['isStatic'] = _$IsStaticEnumMap[instance.isStatic];
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$IsStaticEnumMap = {
  IsStatic.yes: 'yes',
  IsStatic.no: 'no',
  IsStatic.inherited: 'inherited',
};

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ControlEditEnumMap = {
  ControlEdit.inherited: 'inherited',
  ControlEdit.thisOnly: 'thisOnly',
  ControlEdit.thisAndBelow: 'thisAndBelow',
  ControlEdit.pagesOnly: 'pagesOnly',
  ControlEdit.panelsOnly: 'panelsOnly',
  ControlEdit.partsOnly: 'partsOnly',
  ControlEdit.firstLevelPanels: 'firstLevelPanels',
  ControlEdit.noEdit: 'noEdit',
};

PRoute _$PRouteFromJson(Map<String, dynamic> json) {
  return PRoute(
    page: json['page'] == null
        ? null
        : PPage.fromJson(json['page'] as Map<String, dynamic>),
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    dataProvider: PDataProviderConverter.fromJson(
        json['dataProvider'] as Map<String, dynamic>),
    dataSource: PDataSourceConverter.fromJson(
        json['dataSource'] as Map<String, dynamic>),
    panelStyle: json['panelStyle'] == null
        ? null
        : PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle: json['writingStyle'] == null
        ? null
        : WritingStyle.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
  );
}

Map<String, dynamic> _$PRouteToJson(PRoute instance) {
  final val = <String, dynamic>{
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
    'panelStyle': instance.panelStyle?.toJson(),
    'writingStyle': instance.writingStyle?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'dataProvider', PDataProviderConverter.toJson(instance.dataProvider));
  writeNotNull('dataSource', PDataSourceConverter.toJson(instance.dataSource));
  val['page'] = instance.page?.toJson();
  return val;
}

PPage _$PPageFromJson(Map<String, dynamic> json) {
  return PPage(
    pageType: json['pageType'] as String,
    scrollable: json['scrollable'] as bool,
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    content: PElementListConverter.fromJson(
        json['content'] as List<Map<String, dynamic>>),
    dataProvider: PDataProviderConverter.fromJson(
        json['dataProvider'] as Map<String, dynamic>),
    dataSource: PDataSourceConverter.fromJson(
        json['dataSource'] as Map<String, dynamic>),
    panelStyle: json['panelStyle'] == null
        ? null
        : PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle: json['writingStyle'] == null
        ? null
        : WritingStyle.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
    property: json['property'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$PPageToJson(PPage instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
    'panelStyle': instance.panelStyle?.toJson(),
    'writingStyle': instance.writingStyle?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'dataProvider', PDataProviderConverter.toJson(instance.dataProvider));
  writeNotNull('dataSource', PDataSourceConverter.toJson(instance.dataSource));
  val['property'] = instance.property;
  val['pageType'] = instance.pageType;
  val['scrollable'] = instance.scrollable;
  val['content'] = PElementListConverter.toJson(instance.content);
  val['title'] = instance.title;
  return val;
}

PPanel _$PPanelFromJson(Map<String, dynamic> json) {
  return PPanel(
    openExpanded: json['openExpanded'] as bool,
    property: json['property'] as String,
    content: PElementListConverter.fromJson(
        json['content'] as List<Map<String, dynamic>>),
    heading: json['heading'] == null
        ? null
        : PPanelHeading.fromJson(json['heading'] as Map<String, dynamic>),
    caption: json['caption'] as String,
    scrollable: json['scrollable'] as bool,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    style: json['style'] == null
        ? null
        : PPanelStyle.fromJson(json['style'] as Map<String, dynamic>),
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    dataSource: PDataSourceConverter.fromJson(
        json['dataSource'] as Map<String, dynamic>),
    panelStyle: json['panelStyle'] == null
        ? null
        : PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle: json['writingStyle'] == null
        ? null
        : WritingStyle.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$PPanelToJson(PPanel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
    'panelStyle': instance.panelStyle?.toJson(),
    'writingStyle': instance.writingStyle?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('dataSource', PDataSourceConverter.toJson(instance.dataSource));
  val['caption'] = instance.caption;
  val['content'] = PElementListConverter.toJson(instance.content);
  val['openExpanded'] = instance.openExpanded;
  val['scrollable'] = instance.scrollable;
  val['help'] = instance.help?.toJson();
  val['property'] = instance.property;
  val['style'] = instance.style?.toJson();
  val['heading'] = instance.heading?.toJson();
  return val;
}

PPanelHeading _$PPanelHeadingFromJson(Map<String, dynamic> json) {
  return PPanelHeading(
    expandable: json['expandable'] as bool,
    canEdit: json['canEdit'] as bool,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    style: json['style'] == null
        ? null
        : PHeadingStyle.fromJson(json['style'] as Map<String, dynamic>),
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$PPanelHeadingToJson(PPanelHeading instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expandable': instance.expandable,
      'canEdit': instance.canEdit,
      'help': instance.help?.toJson(),
      'style': instance.style?.toJson(),
    };

PCommon _$PCommonFromJson(Map<String, dynamic> json) {
  return PCommon(
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    dataProvider: PDataProviderConverter.fromJson(
        json['dataProvider'] as Map<String, dynamic>),
    dataSource: PDataSourceConverter.fromJson(
        json['dataSource'] as Map<String, dynamic>),
    panelStyle: json['panelStyle'] == null
        ? null
        : PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle: json['writingStyle'] == null
        ? null
        : WritingStyle.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$PCommonToJson(PCommon instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
    'panelStyle': instance.panelStyle?.toJson(),
    'writingStyle': instance.writingStyle?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'dataProvider', PDataProviderConverter.toJson(instance.dataProvider));
  writeNotNull('dataSource', PDataSourceConverter.toJson(instance.dataSource));
  return val;
}
