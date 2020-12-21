import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'form_field.dart';

class FastFormStore with ChangeNotifier, DiagnosticableTreeMixin {
  final Map<String, FastFormFieldState> _fields = {};

  UnmodifiableMapView<String, dynamic> get values => UnmodifiableMapView(
      _fields.map((id, state) => MapEntry(id, state.value)));

  void register(FastFormFieldState state) {
    _fields[state.widget.id] = state;
  }

  void unregister(String id) {
    _fields.remove(id);
  }

  void update(FastFormFieldState state) {
    _fields[state.widget.id] = state;
    notifyListeners();
  }
}
