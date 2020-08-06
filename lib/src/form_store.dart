import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'form_field_group.dart';
import 'utils/form_model.dart';

class FastFormStore with ChangeNotifier, DiagnosticableTreeMixin {
  FastFormStore({
    Map<String, dynamic> initialState,
  }) : this._fields = initialState ?? {};

  final Map<String, dynamic> _fields;

  UnmodifiableMapView<String, dynamic> get fields =>
      UnmodifiableMapView(_fields);

  setValue(String fieldId, dynamic value) {
    _fields[fieldId] = value;
    notifyListeners();
  }

  getValue(String fieldId) {
    return _fields[fieldId];
  }

  static FastFormStore fromModel(List<FastFormFieldGroup> model) {
    return FastFormStore(
      initialState: Map.fromIterable(
        FormModel.flatten(model),
        key: (item) => item.id,
        value: (item) => item.initialValue,
      ),
    );
  }
}
