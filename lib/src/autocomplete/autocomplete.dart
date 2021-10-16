import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_scope.dart';

typedef OptionsMatcher<O extends Object> = bool Function(
    TextEditingValue textEditingValue, O option);

bool _optionsMatcher<O extends Object>(TextEditingValue value, O option) {
  return option.toString().toLowerCase().contains(value.text.toLowerCase());
}

@immutable
class FastAutocomplete<O extends Object> extends FastFormField<String> {
  FastAutocomplete({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<String>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    required String id,
    TextEditingValue? initialValue,
    Key? key,
    String? label,
    ValueChanged<String>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder,
    this.onSelected,
    this.options,
    this.optionsBuilder,
    this.optionsMatcher,
    this.optionsMaxHeight = 200.00,
    this.optionsViewBuilder,
  })  : assert(options != null || optionsBuilder != null),
        _initialValue = initialValue,
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ??
              (field) {
                final scope = FastFormScope.of(field.context);
                final builder =
                    scope?.builders[FastAutocomplete] ?? autocompleteBuilder;
                return builder<O>(field);
              },
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue?.text ?? '',
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final TextEditingValue? _initialValue;
  final AutocompleteOptionToString<O> displayStringForOption;
  final AutocompleteFieldViewBuilder? fieldViewBuilder;
  final AutocompleteOnSelected<O>? onSelected;
  final Iterable<O>? options;
  final AutocompleteOptionsBuilder<O>? optionsBuilder;
  final OptionsMatcher<O>? optionsMatcher;
  final double optionsMaxHeight;
  final AutocompleteOptionsViewBuilder<O>? optionsViewBuilder;

  @override
  FastAutocompleteState<O> createState() => FastAutocompleteState<O>();
}

class FastAutocompleteState<O extends Object>
    extends FastFormFieldState<String> {
  @override
  FastAutocomplete<O> get widget => super.widget as FastAutocomplete<O>;
}

AutocompleteOptionsBuilder<O> _optionsBuilder<O extends Object>(
    Iterable<O> options, FastAutocompleteState<O> state) {
  return (TextEditingValue value) {
    if (value.text.isEmpty) {
      return const Iterable.empty();
    }
    final optionsMatcher = state.widget.optionsMatcher ?? _optionsMatcher;
    return options.where((O option) => optionsMatcher(value, option));
  };
}

AutocompleteFieldViewBuilder _fieldViewBuilder(FastAutocompleteState state) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    final widget = state.widget;
    final theme = Theme.of(state.context);
    final decorator = FastFormScope.of(state.context)?.inputDecorator;
    final _decoration = state.widget.decoration ??
        decorator?.call(state.context, state.widget) ??
        const InputDecoration();
    final InputDecoration effectiveDecoration =
        _decoration.applyDefaults(theme.inputDecorationTheme);

    return TextFormField(
      controller: textEditingController,
      enabled: widget.enabled,
      focusNode: focusNode,
      decoration: effectiveDecoration.copyWith(errorText: state.errorText),
      onChanged: widget.enabled ? state.didChange : null,
      onFieldSubmitted: (String value) => onFieldSubmitted(),
      validator: widget.validator,
    );
  };
}

Autocomplete autocompleteBuilder<O extends Object>(
    FormFieldState<String> field) {
  final state = field as FastAutocompleteState<O>;
  final widget = state.widget;
  final AutocompleteOptionsBuilder<O> optionsBuilder;

  if (widget.optionsBuilder != null) {
    optionsBuilder = widget.optionsBuilder!;
  } else if (widget.options != null) {
    optionsBuilder = _optionsBuilder(widget.options!, state);
  } else {
    throw 'Either optionsBuilder or options must not be null';
  }

  return Autocomplete<O>(
    displayStringForOption: widget.displayStringForOption,
    fieldViewBuilder: _fieldViewBuilder(state),
    initialValue: widget._initialValue,
    onSelected: widget.onSelected,
    optionsBuilder: optionsBuilder,
    optionsMaxHeight: widget.optionsMaxHeight,
    optionsViewBuilder: widget.optionsViewBuilder,
  );
}
