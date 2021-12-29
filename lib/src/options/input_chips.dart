import 'package:flutter/cupertino.dart';
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
    this.feedbackBuilder,
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
  final FastInputChipFeedbackBuilder? feedbackBuilder;
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

class FastDraggableInputChip extends StatelessWidget {
  const FastDraggableInputChip({
    Key? key,
    required this.chipValue,
    required this.field,
    required this.view,
    this.onAccept,
    this.onAcceptWithDetails,
    this.onDragCompleted,
    this.onDragEnd,
    this.onDraggableCanceled,
    this.onDragStarted,
    this.onDragUpdate,
    this.onLeave,
    this.onMove,
    this.onWillAccept,
  }) : super(key: key);

  final String chipValue;
  final FastInputChipsState field;
  final DragTargetAccept<String>? onAccept;
  final DragTargetAcceptWithDetails<String>? onAcceptWithDetails;
  final VoidCallback? onDragCompleted;
  final DragEndCallback? onDragEnd;
  final DraggableCanceledCallback? onDraggableCanceled;
  final VoidCallback? onDragStarted;
  final DragUpdateCallback? onDragUpdate;
  final DragTargetLeave<String>? onLeave;
  final DragTargetMove<String>? onMove;
  final DragTargetWillAccept<String>? onWillAccept;
  final FastInputChipsViewState view;

  EdgeInsets _getDragTargetPadding(bool isTarget) {
    if (isTarget) {
      if (view.dragX == FastInputChipsViewState.dragLR) {
        return const EdgeInsets.only(right: 84.0);
      } else if (view.dragX == FastInputChipsViewState.dragRL) {
        return const EdgeInsets.only(left: 84.0);
      }
    }
    return EdgeInsets.zero;
  }



  @override
  Widget build(BuildContext context) {
    final chipBuilder = field.widget.chipBuilder ?? _chipBuilder;
    final feedbackBuilder = field.widget.feedbackBuilder ?? _feedbackBuilder;

    return DragTarget<String>(
      onAccept: onAccept,
      onAcceptWithDetails: onAcceptWithDetails,
      onLeave: onLeave,
      onMove: onMove,
      onWillAccept: onWillAccept,
      builder: (context, candidateItems, _rejectedItems) {
        final isDropTarget = candidateItems.isNotEmpty;
        return Draggable<String>(
          onDragCompleted: onDragCompleted,
          onDraggableCanceled: onDraggableCanceled,
          onDragEnd: onDragEnd,
          onDragStarted: onDragStarted,
          onDragUpdate: onDragUpdate,
          data: chipValue,
          dragAnchorStrategy: childDragAnchorStrategy,
          maxSimultaneousDrags: 1,
          feedback: feedbackBuilder(chipValue, field),
          childWhenDragging: const Opacity(opacity: 0),
          child: AnimatedPadding(
            duration: Duration(milliseconds: view.dragX == null ? 0 : 200),
            padding: _getDragTargetPadding(isDropTarget),
            child: chipBuilder(chipValue, field),
          ),
        );
      },
    );
  }
}

class FastInputChipsView extends StatefulWidget {
  const FastInputChipsView({
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
  FastInputChipsViewState createState() => FastInputChipsViewState();
}

class FastInputChipsViewState extends State<FastInputChipsView> {
  static const dragRL = -1;
  static const dragLR = 1;

  int? dragX;

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
        for (final chipValue in field.value!)
          FastDraggableInputChip(
            key: ,
            chipValue: chipValue,
            field: field,
            view: this,
            onAccept: (data) {
              final acceptIndex = field.value!.indexOf(data);
              final targetIndex = field.value!.indexOf(chipValue);
              int insertIndex = targetIndex;

              if (acceptIndex < targetIndex && dragX == dragRL) {
                insertIndex--;
              } else if (acceptIndex > targetIndex && dragX == dragLR) {
                insertIndex++;
              }

              widget.field.didChange([...field.value!]
                ..removeAt(acceptIndex)
                ..insert(insertIndex, data));
            },
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
          ),
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
          )
        else
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              print(constraints.minWidth);
              print(constraints.maxWidth);
              return const Text('Hello');
            },
          ),
      ],
    );
  }
}

bool _optionsMatcher(TextEditingValue value, String option) {
  return option.toLowerCase().contains(value.text.toLowerCase());
}

AutocompleteOptionsBuilder<String> _optionsBuilder(
    Iterable<String> options, FastInputChipsState field) {
  return (TextEditingValue value) {
    if (value.text.isEmpty) {
      return const Iterable.empty();
    }
    final optionsMatcher = field.widget.optionsMatcher ?? _optionsMatcher;
    return options.where((option) => optionsMatcher(value, option));
  };
}

AutocompleteFieldViewBuilder _fieldViewBuilder(FastInputChipsState field) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return FastInputChipsView(
      field: field,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textEditingController: textEditingController,
    );
  };
}

void _addChip(String? chipValue, FastInputChipsState field) {
  if (chipValue != null && !field.value!.contains(chipValue)) {
    field.didChange([...field.value!, chipValue]);
    field.textEditingController.clear();
    field.textFocusNode.requestFocus();
  }
}

AutocompleteOptionsViewBuilder<String> _optionsViewBuilder(
    FastInputChipsState field) {
  return (BuildContext context, AutocompleteOnSelected<String> onSelected,
      Iterable<String> options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: field.widget.optionsMaxHeight),
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
                    child: Text(field.widget.displayStringForOption(option)),
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
