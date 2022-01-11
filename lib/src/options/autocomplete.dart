import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastAutocompleteFieldViewBuilder<O extends Object>
    = AutocompleteFieldViewBuilder Function(FastAutocompleteState<O> field);

typedef FastAutocompleteWillAddOption<O extends Object> = bool Function(
    TextEditingValue textEditingValue, O option);

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
    TextEditingValue? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<String>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder,
    this.onSelected,
    this.options,
    this.optionsBuilder,
    this.optionsMaxHeight = 200.00,
    this.optionsViewBuilder,
    this.willAddOption,
  })  : assert(options != null || optionsBuilder != null),
        _initialValue = initialValue,
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? autocompleteBuilder<O>,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue?.text ?? '',
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final TextEditingValue? _initialValue;
  final AutocompleteOptionToString<O> displayStringForOption;
  final FastAutocompleteFieldViewBuilder<O>? fieldViewBuilder;
  final AutocompleteOnSelected<O>? onSelected;
  final Iterable<O>? options;
  final AutocompleteOptionsBuilder<O>? optionsBuilder;
  final double optionsMaxHeight;
  final AutocompleteOptionsViewBuilder<O>? optionsViewBuilder;
  final FastAutocompleteWillAddOption<O>? willAddOption;

  @override
  FastAutocompleteState<O> createState() => FastAutocompleteState<O>();
}

class FastAutocompleteState<O extends Object>
    extends FastFormFieldState<String> {
  @override
  FastAutocomplete<O> get widget => super.widget as FastAutocomplete<O>;
}

bool _willAddOption<O extends Object>(TextEditingValue value, O option) {
  return option.toString().toLowerCase().contains(value.text.toLowerCase());
}

AutocompleteOptionsBuilder<O> _optionsBuilder<O extends Object>(
    Iterable<O> options, FastAutocompleteState<O> field) {
  return (TextEditingValue value) {
    if (value.text.isEmpty) {
      return const Iterable.empty();
    }
    final willAddOption = field.widget.willAddOption ?? _willAddOption;
    return options.where((O option) => willAddOption(value, option));
  };
}

AutocompleteFieldViewBuilder _fieldViewBuilder<O extends Object>(
    FastAutocompleteState<O> field) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    final widget = field.widget;

    return TextFormField(
      controller: textEditingController,
      enabled: widget.enabled,
      focusNode: focusNode,
      decoration: field.decoration.copyWith(errorText: field.errorText),
      onChanged: widget.enabled ? field.didChange : null,
      onFieldSubmitted: (String value) => onFieldSubmitted(),
      validator: widget.validator,
    );
  };
}

Autocomplete autocompleteBuilder<O extends Object>(
    FormFieldState<String> field) {
  final widget = (field as FastAutocompleteState<O>).widget;
  final fieldViewBuilder = widget.fieldViewBuilder ?? _fieldViewBuilder;
  final AutocompleteOptionsBuilder<O> optionsBuilder;

  if (widget.optionsBuilder != null) {
    optionsBuilder = widget.optionsBuilder!;
  } else if (widget.options != null) {
    optionsBuilder = _optionsBuilder(widget.options!, field);
  } else {
    throw 'Either optionsBuilder or options must not be null';
  }

  return Autocomplete<O>(
    displayStringForOption: widget.displayStringForOption,
    fieldViewBuilder: fieldViewBuilder(field),
    initialValue: widget._initialValue,
    onSelected: widget.onSelected,
    optionsBuilder: optionsBuilder,
    optionsMaxHeight: widget.optionsMaxHeight,
    optionsViewBuilder: widget.optionsViewBuilder,
  );
}
