import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'form_field_group.dart';
import 'utils/form_model.dart';

class FastFormStore with ChangeNotifier, DiagnosticableTreeMixin {
  FastFormStore({
    Map<int, dynamic> initialState,
  }) : this._fields = initialState ?? {};

  final Map<int, dynamic> _fields;

  UnmodifiableMapView<int, dynamic> get fields => UnmodifiableMapView(_fields);

  setValue(int fieldId, dynamic value) {
    _fields[fieldId] = value;
    notifyListeners();
  }

  getValue(int fieldId) {
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
