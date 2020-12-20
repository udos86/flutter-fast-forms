import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_store.dart';

typedef FastFormFieldBuilder = Widget Function(
    BuildContext context, FastFormFieldState state);

@immutable
abstract class FastFormField<T> extends StatefulWidget {
  const FastFormField({
    this.autofocus = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
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
  final AutovalidateMode autovalidateMode;
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

  FocusNode focusNode;
  FastFormStore store;
  T value;

  @override
  void initState() {
    super.initState();

    store = Provider.of<FastFormStore>(context, listen: false);

    if (store.isRestored(widget.id)) {
      value = store.getInitialValue(widget.id);
      touched = true;
    } else {
      value = widget.initialValue;
    }

    focusNode = FocusNode();
    focusNode.addListener(_onFocusChanged);
  }

  @override
  void deactivate() {
    store.unregister(widget.id);
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    store.register(this);
    return widget.builder(context, this);
  }

  void onChanged(T value) {
    if (!touched) setState(() => touched = true);
    this.value = value;
    store.update(this);
  }

  void onReset() {
    setState(() {
      focused = false;
      touched = false;
      value = widget.initialValue;
      store.update(this);
    });
  }

  void onSaved(T value) {
    this.value = value;
    store.update(this);
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
