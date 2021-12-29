import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../form_field.dart';

import 'autocomplete.dart';

typedef FastInputChipBuilder = InputChip Function(
    String chipValue, FastInputChipsState field);

typedef FastInputChipFeedbackBuilder = Widget Function(
    String chipValue, FastInputChipsState field);

@immutable
class FastInputChips extends FastFormField<List<String>> {
  FastInputChips({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<List<String>>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    List<String>? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<List<String>>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<List<String>>? onSaved,
    FormFieldValidator<List<String>>? validator,
    this.alignment = WrapAlignment.start,
    this.chipBuilder,
    this.clipBehavior = Clip.none,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder,
    this.fieldViewValidator,
    this.fieldViewWidth = 80.0,
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
          initialValue: initialValue ?? <String>[],
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

class FastInputChipsState extends FastFormFieldState<List<String>> {
  final textEditingController = TextEditingController();
  final textFocusNode = FocusNode();

  @override
  FastInputChips get widget => super.widget as FastInputChips;
}

InputChip _chipBuilder(String chipValue, FastInputChipsState field) {
  return InputChip(
    label: Text(chipValue),
    isEnabled: field.widget.enabled,
    onDeleted: () => field.didChange([...field.value!]..remove(chipValue)),
  );
}

Widget _feedbackBuilder(String chipValue, FastInputChipsState _field) {
  return Material(
    type: MaterialType.transparency,
    child: InputChip(
      isEnabled: true,
      label: Text(chipValue),
      onDeleted: () {},
    ),
  );
}

class _FastDraggableInputChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _FastInputChipsWrap extends StatefulWidget {
  const _FastInputChipsWrap({
    Key? key,
    required this.field,
    required this.focusNode,
    required this.onFieldSubmitted,
    required this.textEditingController,
  }) : super(key: key);

  final FastInputChipsState field;
  final FocusNode focusNode;
  final VoidCallback onFieldSubmitted;
  final TextEditingController textEditingController;

  @override
  _FastInputChipsWrapState createState() => _FastInputChipsWrapState();
}

class _FastInputChipsWrapState extends State<_FastInputChipsWrap> {
  static const dragRL = -1;
  static const dragLR = 1;

  int? dragX;

  EdgeInsets _getDragTargetPadding(bool isTargeted) {
    if (isTargeted) {
      if (dragX == dragLR) {
        return const EdgeInsets.only(right: 84.0);
      } else if (dragX == dragRL) {
        return const EdgeInsets.only(left: 84.0);
      }
    }
    return EdgeInsets.zero;
  }

  Widget _buildChip(String chipValue) {
    final chipBuilder = widget.field.widget.chipBuilder ?? _chipBuilder;
    final fieldValue = widget.field.value!;

    return DragTarget<String>(
      onAccept: (data) {
        final acceptIndex = fieldValue.indexOf(data);
        final targetIndex = fieldValue.indexOf(chipValue);

        int insertIndex = targetIndex;
        if (acceptIndex < targetIndex && dragX == dragRL) insertIndex--;
        if (acceptIndex > targetIndex && dragX == dragLR) insertIndex++;

        widget.field.didChange([...fieldValue]
          ..removeAt(acceptIndex)
          ..insert(insertIndex, data));
      },
      builder: (context, candidateItems, _rejectedItems) {
        final isTarget = candidateItems.isNotEmpty;
        return Draggable<String>(
          onDragEnd: (_details) {
            setState(() => dragX = null);
          },
          onDragUpdate: (details) {
            if (details.delta.dx != 0.0) {
              setState(() {
                dragX = details.delta.dx.round().clamp(dragRL, dragLR);
              });
            }
          },
          data: chipValue,
          dragAnchorStrategy: childDragAnchorStrategy,
          maxSimultaneousDrags: 1,
          feedback: _feedbackBuilder(chipValue, widget.field),
          childWhenDragging: const Opacity(opacity: 0),
          child: AnimatedPadding(
            duration: Duration(milliseconds: dragX == null ? 0 : 200),
            padding: _getDragTargetPadding(isTarget),
            child: chipBuilder(chipValue, widget.field),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.field;
    return Wrap(
      alignment: field.widget.alignment,
      clipBehavior: field.widget.clipBehavior,
      crossAxisAlignment: field.widget.crossAxisAlignment,
      direction: field.widget.direction,
      spacing: field.widget.spacing,
      runAlignment: field.widget.runAlignment,
      runSpacing: field.widget.runSpacing,
      textDirection: field.widget.textDirection,
      verticalDirection: field.widget.verticalDirection,
      children: [
        for (final chipValue in field.value!) _buildChip(chipValue),
        if (dragX == null)
          SizedBox(
            width: field.widget.fieldViewWidth,
            child: TextFormField(
              controller: widget.textEditingController,
              decoration: const InputDecoration(border: InputBorder.none),
              enabled: field.widget.enabled,
              focusNode: widget.focusNode,
              onFieldSubmitted: (String value) {
                if (value.isEmpty) {
                  widget.focusNode.unfocus();
                } else {
                  widget.onFieldSubmitted();
                  _addChip(value, field);
                }
              },
              validator: field.widget.fieldViewValidator,
            ),
          ),
      ],
    );
  }
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

void _addChip(String? chipValue, FastInputChipsState field) {
  if (chipValue != null && !field.value!.contains(chipValue)) {
    field.didChange([...field.value!, chipValue]);
    field.textEditingController.clear();
    field.textFocusNode.requestFocus();
  }
}

AutocompleteFieldViewBuilder _fieldViewBuilder(FastInputChipsState field) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return _FastInputChipsWrap(
      field: field,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textEditingController: textEditingController,
    );
  };
}

AutocompleteOptionsViewBuilder<String> _optionsViewBuilder(
    FastInputChipsState state) {
  return (BuildContext context, AutocompleteOnSelected<String> onSelected,
      Iterable<String> options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: state.widget.optionsMaxHeight),
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
                    child: Text(state.widget.displayStringForOption(option)),
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

Widget inputChipsBuilder(FormFieldState<List<String>> field) {
  final _field = field as FastInputChipsState;
  final widget = _field.widget;

  return GestureDetector(
    onTap: widget.enabled ? () => _field.textFocusNode.requestFocus() : null,
    child: InputDecorator(
      decoration: _field.decoration.copyWith(
        contentPadding: widget.contentPadding,
        errorText: _field.errorText,
      ),
      child: RawAutocomplete<String>(
        displayStringForOption: widget.displayStringForOption,
        fieldViewBuilder: _fieldViewBuilder(_field),
        focusNode: _field.textFocusNode,
        onSelected: (String? value) => _addChip(value, _field),
        optionsBuilder: _optionsBuilder(widget.options, _field),
        optionsViewBuilder:
            widget.optionsViewBuilder ?? _optionsViewBuilder(_field),
        textEditingController: _field.textEditingController,
      ),
    ),
  );
}
