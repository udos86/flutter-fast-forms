import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef SwitchTitleBuilder = Widget Function(FastSwitchState state);

@immutable
class FastSwitch extends FastFormField<bool> {
  FastSwitch({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<bool>? builder,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.symmetric(horizontal: 16.0),
    InputDecoration? decoration,
    bool enabled = true,
    String? helper,
    required String id,
    bool initialValue = false,
    Key? key,
    String? label,
    ValueChanged<bool>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<bool>? onSaved,
    required this.title,
    SwitchTitleBuilder? titleBuilder,
    FormFieldValidator<bool>? validator,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final state = field as FastSwitchState;
                final theme = Theme.of(state.context);
                final decorator =
                    FastFormScope.of(state.context)?.inputDecorator;
                final _decoration = decoration ??
                    decorator?.call(state.context, state.widget) ??
                    const InputDecoration();
                final InputDecoration effectiveDecoration =
                    _decoration.applyDefaults(theme.inputDecorationTheme);
                final _titleBuilder = titleBuilder ?? switchTitleBuilder;
                return InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: state.errorText,
                  ),
                  child: SwitchListTile.adaptive(
                    autofocus: autofocus,
                    contentPadding: contentPadding,
                    onChanged: enabled ? state.didChange : null,
                    selected: state.value!,
                    title: title is String ? _titleBuilder(state) : null,
                    value: state.value!,
                  ),
                );
              },
          decoration: decoration,
          enabled: enabled,
          helper: helper,
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

  @override
  FastSwitchState createState() => FastSwitchState();
}

class FastSwitchState extends FastFormFieldState<bool> {
  @override
  FastSwitch get widget => super.widget as FastSwitch;
}

final SwitchTitleBuilder switchTitleBuilder = (FastSwitchState state) {
  return Text(
    state.widget.title,
    style: TextStyle(
      fontSize: 14.0,
      color: state.value! ? Colors.black : Colors.grey,
    ),
  );
};
