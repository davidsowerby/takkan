// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PScript _$PScriptFromJson(Map<String, dynamic> json) {
  return PScript(
    components: (json['components'] as List)
        .map((e) => PComponent.fromJson(e as Map<String, dynamic>))
        .toList(),
    name: json['name'] as String,
    isStatic: _$enumDecode(_$IsStaticEnumMap, json['isStatic']),
    backend: json['backend'] == null
        ? null
        : PBackend.fromJson(json['backend'] as Map<String, dynamic>),
    dataSource: json['dataSource'] == null
        ? null
        : PDataSource.fromJson(json['dataSource'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
  );
}

Map<String, dynamic> _$PScriptToJson(PScript instance) {
  final val = <String, dynamic>{
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'name': instance.name,
    'components': instance.components.map((e) => e.toJson()).toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backend', instance.backend?.toJson());
  writeNotNull('dataSource', instance.dataSource?.toJson());
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
  ControlEdit.notSetAtThisLevel: 'notSetAtThisLevel',
  ControlEdit.thisOnly: 'thisOnly',
  ControlEdit.thisAndBelow: 'thisAndBelow',
  ControlEdit.pagesOnly: 'pagesOnly',
  ControlEdit.panelsOnly: 'panelsOnly',
  ControlEdit.partsOnly: 'partsOnly',
  ControlEdit.firstLevelPanels: 'firstLevelPanels',
  ControlEdit.noEdit: 'noEdit',
};

PComponent _$PComponentFromJson(Map<String, dynamic> json) {
  return PComponent(
    routes: (json['routes'] as List)
        .map((e) => PRoute.fromJson(e as Map<String, dynamic>))
        .toList(),
    name: json['name'] as String,
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    backend: json['backend'] == null
        ? null
        : PBackend.fromJson(json['backend'] as Map<String, dynamic>),
    dataSource: json['dataSource'] == null
        ? null
        : PDataSource.fromJson(json['dataSource'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
  );
}

Map<String, dynamic> _$PComponentToJson(PComponent instance) {
  final val = <String, dynamic>{
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backend', instance.backend?.toJson());
  writeNotNull('dataSource', instance.dataSource?.toJson());
  val['name'] = instance.name;
  val['routes'] = instance.routes.map((e) => e.toJson()).toList();
  return val;
}

PRoute _$PRouteFromJson(Map<String, dynamic> json) {
  return PRoute(
    path: json['path'] as String,
    page: json['page'] == null
        ? null
        : PPage.fromJson(json['page'] as Map<String, dynamic>),
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    backend: json['backend'] == null
        ? null
        : PBackend.fromJson(json['backend'] as Map<String, dynamic>),
    dataSource: json['dataSource'] == null
        ? null
        : PDataSource.fromJson(json['dataSource'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
  );
}

Map<String, dynamic> _$PRouteToJson(PRoute instance) {
  final val = <String, dynamic>{
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backend', instance.backend?.toJson());
  writeNotNull('dataSource', instance.dataSource?.toJson());
  val['path'] = instance.path;
  val['page'] = instance.page?.toJson();
  return val;
}

PPage _$PPageFromJson(Map<String, dynamic> json) {
  return PPage(
    pageType: json['pageType'] as String,
    title: json['title'] as String,
    scrollable: json['scrollable'] as bool,
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    content: PElementListConverter.fromJson(
        json['content'] as List<Map<String, dynamic>>),
    backend: json['backend'] == null
        ? null
        : PBackend.fromJson(json['backend'] as Map<String, dynamic>),
    dataSource: json['dataSource'] == null
        ? null
        : PDataSource.fromJson(json['dataSource'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
  );
}

Map<String, dynamic> _$PPageToJson(PPage instance) {
  final val = <String, dynamic>{
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backend', instance.backend?.toJson());
  writeNotNull('dataSource', instance.dataSource?.toJson());
  val['title'] = instance.title;
  val['pageType'] = instance.pageType;
  val['scrollable'] = instance.scrollable;
  val['content'] = PElementListConverter.toJson(instance.content);
  return val;
}

PPanel _$PPanelFromJson(Map<String, dynamic> json) {
  return PPanel(
    property: json['property'] as String,
    content: PElementListConverter.fromJson(
        json['content'] as List<Map<String, dynamic>>),
    caption: json['caption'] as String,
    scrollable: json['scrollable'] as bool,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    style: json['style'] == null
        ? null
        : PPanelStyle.fromJson(json['style'] as Map<String, dynamic>),
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    backend: json['backend'] == null
        ? null
        : PBackend.fromJson(json['backend'] as Map<String, dynamic>),
    dataSource: json['dataSource'] == null
        ? null
        : PDataSource.fromJson(json['dataSource'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
  );
}

Map<String, dynamic> _$PPanelToJson(PPanel instance) {
  final val = <String, dynamic>{
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backend', instance.backend?.toJson());
  writeNotNull('dataSource', instance.dataSource?.toJson());
  val['caption'] = instance.caption;
  val['content'] = PElementListConverter.toJson(instance.content);
  val['scrollable'] = instance.scrollable;
  val['help'] = instance.help?.toJson();
  val['property'] = instance.property;
  val['style'] = instance.style?.toJson();
  return val;
}

PPanelHeading _$PPanelHeadingFromJson(Map<String, dynamic> json) {
  return PPanelHeading(
    title: json['title'] as String,
    expandable: json['expandable'] as bool,
    openExpanded: json['openExpanded'] as bool,
    canEdit: json['canEdit'] as bool,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    style: json['style'] == null
        ? null
        : PHeadingStyle.fromJson(json['style'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PPanelHeadingToJson(PPanelHeading instance) =>
    <String, dynamic>{
      'title': instance.title,
      'expandable': instance.expandable,
      'openExpanded': instance.openExpanded,
      'canEdit': instance.canEdit,
      'help': instance.help?.toJson(),
      'style': instance.style?.toJson(),
    };

PCommon _$PCommonFromJson(Map<String, dynamic> json) {
  return PCommon(
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    backend: json['backend'] == null
        ? null
        : PBackend.fromJson(json['backend'] as Map<String, dynamic>),
    dataSource: const PDataSourceConverter()
        .fromJson(json['dataSource'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
  );
}

Map<String, dynamic> _$PCommonToJson(PCommon instance) {
  final val = <String, dynamic>{
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$IsStaticEnumMap[instance.isStatic],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backend', instance.backend?.toJson());
  writeNotNull(
      'dataSource', const PDataSourceConverter().toJson(instance.dataSource));
  return val;
}
