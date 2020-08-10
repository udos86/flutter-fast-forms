import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'form_field_group.dart';
import 'utils/form_model.dart';

@immutable
class FastFormStoreField {
  FastFormStoreField({
    this.restored = false,
    this.value,
  });

  final bool restored;
  final dynamic value;
}

class FastFormStore with ChangeNotifier, DiagnosticableTreeMixin {
  FastFormStore({
    Map<String, dynamic> initialState,
  }) : this._fields = initialState ?? {};

  final Map<String, FastFormStoreField> _fields;

  UnmodifiableMapView<String, dynamic> get values => UnmodifiableMapView(
      _fields.map((fieldId, value) => MapEntry(fieldId, value.value)));

  void setValue(String fieldId, dynamic value) {
    _fields[fieldId] = FastFormStoreField(value: value);
    notifyListeners();
  }

  dynamic getValue(String fieldId) {
    return _fields[fieldId].value;
  }

  bool restored(String fieldId) {
    return _fields[fieldId].restored;
  }

  static Map<String, FastFormStoreField> fromModel(
      List<FastFormFieldGroup> model) {
    return Map.fromIterable(
      FormModel.flatten(model),
      key: (item) => item.id,
      value: (item) => FastFormStoreField(value: item.initialValue),
    );
  }

  static Map<String, FastFormStoreField> fromValues(Map<String, dynamic> values,
      [markAsRestored = true]) {
    return values?.map(
          (fieldId, value) => MapEntry(fieldId,
              FastFormStoreField(value: value, restored: markAsRestored)),
        ) ??
        {};
  }
}
