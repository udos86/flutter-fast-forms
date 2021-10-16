import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef CheckboxTitleBuilder = Widget Function(FastCheckboxState state);

@immutable
class FastCheckbox extends FastFormField<bool> {
  FastCheckbox({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<bool>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    bool initialValue = false,
    Key? key,
    String? label,
    ValueChanged<bool>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    required this.title,
    this.titleBuilder,
    this.tristate = false,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder =
                    scope?.builders[FastCheckbox] ?? checkboxBuilder;
                return builder(field);
              },
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String title;
  final CheckboxTitleBuilder? titleBuilder;
  final bool tristate;

  @override
  FastCheckboxState createState() => FastCheckboxState();
}

class FastCheckboxState extends FastFormFieldState<bool> {
  @override
  FastCheckbox get widget => super.widget as FastCheckbox;
}

Text checkboxTitleBuilder(FastCheckboxState state) {
  return Text(
    state.widget.title,
    style: TextStyle(
      fontSize: 14.0,
      color: state.value! ? Colors.black : Colors.grey,
    ),
  );
}

InputDecorator checkboxBuilder(FormFieldState<bool> field) {
  final state = field as FastCheckboxState;
  final widget = state.widget;

  final theme = Theme.of(state.context);
  final decorator = FastFormScope.of(state.context)?.inputDecorator;
  final _decoration = widget.decoration ??
      decorator?.call(state.context, state.widget) ??
      const InputDecoration();
  final InputDecoration effectiveDecoration =
      _decoration.applyDefaults(theme.inputDecorationTheme);
  final _titleBuilder = widget.titleBuilder ?? checkboxTitleBuilder;

  return InputDecorator(
    decoration: effectiveDecoration.copyWith(
      errorText: state.errorText,
    ),
    child: CheckboxListTile(
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      onChanged: widget.enabled ? state.didChange : null,
      selected: state.value ?? false,
      title: widget.title is String ? _titleBuilder(state) : null,
      tristate: widget.tristate,
      value: state.value,
    ),
  );
}
