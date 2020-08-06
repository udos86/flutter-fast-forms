import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:provider/provider.dart';

typedef FastFormFieldBuilder = Widget Function(
    BuildContext context, FastFormFieldState state);

@immutable
abstract class FastFormField<T> extends StatefulWidget {
  const FastFormField({
    @required this.builder,
    this.decoration,
    this.enabled = true,
    this.helper,
    @required this.id,
    this.initialValue,
    this.label,
    this.validator,
  });

  final FastFormFieldBuilder builder;
  final InputDecoration decoration;
  final bool enabled;
  final String helper;
  final String id;
  final T initialValue;
  final String label;
  final FormFieldValidator validator;

  T get value => initialValue;
}

class FastFormFieldState<T> extends State<FastFormField> {
  T value;

  bool get autovalidate => true;

  FastFormStore get store => Provider.of<FastFormStore>(context, listen: false);

  @override
  void initState() {
    super.initState();
    value = store.getValue(widget.id) ?? widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }

  void reset() {
    this.value = widget.initialValue;
  }

  void onSaved(T value) {
    _store(value);
  }

  void onChanged(T value) {
    _store(value);
  }

  void _store(T value) {
    this.value = value;
    store.setValue(widget.id, value);
  }
}
