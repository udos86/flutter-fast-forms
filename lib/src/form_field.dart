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
  bool dirty = false;
  bool focused = false;
  bool touched = false;

  T value;
  FocusNode focusNode;

  bool get autovalidate => dirty || touched;

  @override
  void initState() {
    final store = Provider.of<FastFormStore>(context, listen: false);
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(_onFocusChanged);
    if (store.restored(widget.id)) {
      dirty = true;
      value = store.getValue(widget.id);
    } else {
      value = widget.initialValue;
    }
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

  void reset() {
    setState(() {
      dirty = false;
      focused = false;
      touched = false;
      value = widget.initialValue;
    });
  }

  void markAsDirty([bool dirty = true]) {
    if (this.dirty != dirty) {
      setState(() => this.dirty = dirty);
    }
  }

  void markAsFocused([bool focused = true]) {
    if (this.focused != focused) {
      setState(() => this.focused = focused);
    }
  }

  void markAsTouched([bool touched = true]) {
    if (this.touched != touched) {
      setState(() => this.touched = touched);
    }
  }

  void onChanged(T value) {
    if (!dirty) markAsDirty();
    if (!touched) markAsTouched();
    _store(value);
  }

  void onSaved(T value) {
    _store(value);
  }

  void onTouched() {
    markAsTouched();
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus) {
      markAsFocused();
    } else {
      markAsFocused(false);
      if (!touched) markAsTouched();
    }
  }

  void _store(T value) {
    final store = Provider.of<FastFormStore>(context, listen: false);
    this.value = value;
    store.setValue(widget.id, value);
  }
}
