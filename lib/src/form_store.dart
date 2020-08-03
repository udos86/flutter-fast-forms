import 'package:flutter/foundation.dart';

class FastFormStore with ChangeNotifier, DiagnosticableTreeMixin {
  final Map<int, dynamic> fields = {};

  setValue(fieldId, dynamic value) {
    fields[fieldId] = value;
    notifyListeners();
  }
}
