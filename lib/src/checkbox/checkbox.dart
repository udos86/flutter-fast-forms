import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';

typedef CheckboxTitleBuilder = Widget Function(
    BuildContext context, FastCheckboxState state);

class FastCheckbox extends FastFormField<bool> {
  FastCheckbox({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<bool> builder,
    InputDecoration decoration,
    bool enabled = true,
    String helper,
    @required String id,
    bool initialValue,
    Key key,
    String label,
    ValueChanged<bool> onChanged,
    VoidCallback onReset,
    FormFieldSetter<bool> onSaved,
    this.title,
    CheckboxTitleBuilder titleBuilder,
    bool tristate = false,
    FormFieldValidator<bool> validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastCheckboxState;
                final theme = Theme.of(state.context);
                final formTheme = FastFormTheme.of(state.context);
                final _decoration = decoration ??
                    formTheme.getInputDecoration(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
                final _titleBuilder = titleBuilder ?? checkboxTitleBuilder;
                return InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: state.errorText,
                  ),
                  child: CheckboxListTile(
                    autofocus: autofocus,
                    onChanged: enabled ? state.didChange : null,
                    selected: state.value,
                    tristate: tristate,
                    title: title is String
                        ? _titleBuilder(state.context, state)
                        : null,
                    value: state.value,
                  ),
                );
              },
          helper: helper,
          enabled: enabled,
          id: id,
          initialValue: initialValue ?? false,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String title;

  @override
  FormFieldState<bool> createState() => FastCheckboxState();
}

class FastCheckboxState extends FastFormFieldState<bool> {
  @override
  FastCheckbox get widget => super.widget as FastCheckbox;
}

final CheckboxTitleBuilder checkboxTitleBuilder =
    (BuildContext context, FastCheckboxState state) {
  return Text(
    state.widget.title,
    style: TextStyle(
      fontSize: 14.0,
      color: state.value ? Colors.black : Colors.grey,
    ),
  );
};
