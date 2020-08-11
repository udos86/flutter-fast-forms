import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_store.dart';

typedef FastFormFieldBuilder = Widget Function(
    BuildContext context, FastFormFieldState state);

@immutable
abstract class FastFormField<T> extends StatefulWidget {
  const FastFormField({
    this.autofocus = false,
    @required this.builder,
    this.decoration,
    this.enabled = true,
    this.helper,
    @required this.id,
    this.initialValue,
    this.label,
    this.validator,
  });

  final bool autofocus;
  final FastFormFieldBuilder builder;
  final InputDecoration decoration;
  final bool enabled;
  final String helper;
  final String id;
  final T initialValue;
  final String label;
  final FormFieldValidator validator;
}

class FastFormFieldState<T> extends State<FastFormField> {
  bool focused = false;
  bool touched = false;

  T value;
  FocusNode focusNode;

  bool get autovalidate => touched;

  FastFormStore get store => Provider.of<FastFormStore>(context, listen: false);

  @override
  void initState() {
    super.initState();

    final _store = store;

    if (_store.isFieldRestored(widget.id)) {
      value = _store.getInitialValue(widget.id);
      touched = true;
    } else {
      value = widget.initialValue;
    }

    focusNode = FocusNode();
    focusNode.addListener(_onFocusChanged);

    _store.initField(this);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }

  void onReset() {
    focused = false;
    touched = false;
    value = widget.initialValue;
    store.updateField(this);
  }

  void onChanged(T value) {
    if (!touched) setState(() => touched = true);
    this.value = value;
    store.updateField(this);
  }

  void onSaved(T value) {
    this.value = value;
    store.updateField(this);
  }

  void _onFocusChanged() {
    setState(() {
      if (focusNode.hasFocus) {
        focused = true;
      } else {
        focused = false;
        touched = true;
      }
    });
  }
}
