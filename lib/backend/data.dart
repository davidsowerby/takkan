import 'package:flutter/foundation.dart';
import 'package:precept_script/script/documentId.dart';

class Data {
  final DocumentId documentId;
  final Map<String, dynamic> data;

  const Data({@required this.data,@required this.documentId});
}