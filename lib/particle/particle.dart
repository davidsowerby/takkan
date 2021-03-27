import 'package:precept_script/data/converter/converter.dart';

/// [viewDataType] is the [Type] used by the Widget to display its data.  It needs to be defined to enable
/// construction of the correct [ModelViewConverter]
abstract class Particle {
  Type get viewDataType;
}
