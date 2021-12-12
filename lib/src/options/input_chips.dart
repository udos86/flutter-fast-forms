import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../form_field.dart';

import 'autocomplete.dart';

typedef FastInputChipBuilder = InputChip Function(
    String value, FastInputChipsState state);

@immutable
class FastInputChips extends FastFormField<Set<String>> {
  FastInputChips({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<Set<String>>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    Set<String>? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<Set<String>>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<Set<String>>? onSaved,
    FormFieldValidator<Set<String>>? validator,
    this.alignment = WrapAlignment.start,
    this.chipBuilder,
    this.clipBehavior = Clip.none,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder,
    this.fieldViewValidator,
    this.fieldViewWidth = 120.0,
    this.onSelected,
    this.options = const [],
    this.optionsBuilder,
    this.optionsMatcher,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.spacing = 8.0,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? inputChipsBuilder,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue ?? <String>{},
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final WrapAlignment alignment;
  final FastInputChipBuilder? chipBuilder;
  final Clip clipBehavior;
  final WrapCrossAlignment crossAxisAlignment;
  final Axis direction;
  final AutocompleteOptionToString<String> displayStringForOption;
  final FastAutocompleteFieldViewBuilder<String>? fieldViewBuilder;
  final FormFieldValidator<String>? fieldViewValidator;
  final double fieldViewWidth;
  final AutocompleteOnSelected<String>? onSelected;
  final Iterable<String> options;
  final AutocompleteOptionsBuilder<String>? optionsBuilder;
  final FastOptionsMatcher<String>? optionsMatcher;
  final double optionsMaxHeight;
  final AutocompleteOptionsViewBuilder<String>? optionsViewBuilder;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final double spacing;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;

  @override
  FastInputChipsState createState() => FastInputChipsState();
}

class FastInputChipsState extends FastFormFieldState<Set<String>> {
  final textEditingController = TextEditingController();
  final textFocusNode = FocusNode();

  @override
  FastInputChips get widget => super.widget as FastInputChips;
}

bool _optionsMatcher(TextEditingValue value, String option) {
  return option.toLowerCase().contains(value.text.toLowerCase());
}

AutocompleteOptionsBuilder<String> _optionsBuilder(
    Iterable<String> options, FastInputChipsState state) {
  return (TextEditingValue value) {
    if (value.text.isEmpty) {
      return const Iterable.empty();
    }
    final optionsMatcher = state.widget.optionsMatcher ?? _optionsMatcher;
    return options.where((option) => optionsMatcher(value, option));
  };
}

void _updateField(String? value, FastInputChipsState state) {
  if (value != null) {
    state.didChange({...state.value!, value});
    state.textEditingController.clear();
    state.textFocusNode.requestFocus();
  }
}

InputChip _chipBuilder(String value, FastInputChipsState state) {
  return InputChip(
    label: Text(value),
    isEnabled: state.widget.enabled,
    onDeleted: () => state.didChange({...state.value!}..remove(value)),
  );
}

AutocompleteFieldViewBuilder _fieldViewBuilder(FastInputChipsState state) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    final widget = state.widget;
    final chipBuilder = widget.chipBuilder ?? _chipBuilder;

    return Wrap(
      alignment: widget.alignment,
      clipBehavior: widget.clipBehavior,
      crossAxisAlignment: widget.crossAxisAlignment,
      direction: widget.direction,
      spacing: widget.spacing,
      runAlignment: widget.runAlignment,
      runSpacing: widget.runSpacing,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      children: [
        for (var value in state.value!) chipBuilder(value, state),
        SizedBox(
          width: widget.fieldViewWidth,
          child: TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(border: InputBorder.none),
            enabled: widget.enabled,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              if (value.isEmpty) {
                focusNode.unfocus();
              } else {
                onFieldSubmitted();
                _updateField(value, state);
              }
            },
            validator: widget.fieldViewValidator,
          ),
        )
      ],
    );
  };
}

AutocompleteOptionsViewBuilder<String> _optionsViewBuilder(
    FastInputChipsState state) {
  return (BuildContext context, AutocompleteOnSelected<String> onSelected,
      Iterable<String> options) {
    final widget = state.widget;

    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: widget.optionsMaxHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final String option = options.elementAt(index);
              return InkWell(
                onTap: () => onSelected(option),
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance!
                        .addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.displayStringForOption(option)),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  };
}

Widget inputChipsBuilder(FormFieldState<Set<String>> field) {
  final state = field as FastInputChipsState;
  final widget = state.widget;

  return GestureDetector(
    onTap: widget.enabled ? () => state.textFocusNode.requestFocus() : null,
    child: InputDecorator(
      decoration: state.decoration.copyWith(
        contentPadding: widget.contentPadding,
        errorText: state.errorText,
      ),
      child: RawAutocomplete<String>(
        displayStringForOption: widget.displayStringForOption,
        fieldViewBuilder: _fieldViewBuilder(state),
        focusNode: state.textFocusNode,
        onSelected: (String? value) => _updateField(value, state),
        optionsBuilder: _optionsBuilder(widget.options, state),
        optionsViewBuilder:
            widget.optionsViewBuilder ?? _optionsViewBuilder(state),
        textEditingController: state.textEditingController,
      ),
    ),
  );
}
