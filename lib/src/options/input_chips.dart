import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    this.fieldViewMinWidth = 80.0,
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
  final double fieldViewMinWidth;
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

typedef ChipDragTargetMove<T> = void Function(
    DragTargetDetails<T> details, String chip);

class FastDraggableInputChip extends StatelessWidget {
  const FastDraggableInputChip({
    Key? key,
    required this.chipValue,
    required this.field,
    required this.view,
    this.onAccept,
    this.onAcceptWithDetails,
    this.onAnimationEnd,
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
  final VoidCallback? onAnimationEnd;
  final VoidCallback? onDragCompleted;
  final DragEndCallback? onDragEnd;
  final DraggableCanceledCallback? onDraggableCanceled;
  final VoidCallback? onDragStarted;
  final DragUpdateCallback? onDragUpdate;
  final DragTargetLeave<String>? onLeave;
  final ChipDragTargetMove<String>? onMove;
  final DragTargetWillAccept<String>? onWillAccept;
  final FastInputChipsViewState view;

  @override
  Widget build(BuildContext context) {
    final feedbackBuilder = field.widget.feedbackBuilder ?? _feedbackBuilder;

    return DragTarget<String>(
      onAccept: onAccept,
      onAcceptWithDetails: onAcceptWithDetails,
      onLeave: onLeave,
      onMove: (details) => onMove?.call(details, chipValue),
      onWillAccept: onWillAccept,
      builder: (context, candidateItems, _rejectedItems) {
        final isDropTarget = candidateItems.isNotEmpty;
        final chipBuilder = field.widget.chipBuilder ?? _chipBuilder;
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
          childWhenDragging: const SizedBox.shrink(),
          child: chipBuilder(chipValue, field),
          /*
          child: Padding(
            // duration: Duration(milliseconds: view.dragX == null ? 0 : 200),
            padding: _getDragTargetPadding(isDropTarget),
            child: chipBuilder(chipValue, field),
          ),
          */
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

  final wrapKey = GlobalKey();

  int? dragX;
  String? dragChip;
  double? freeWidth;
  int? gapIndex;
  List<List<RenderBox>> runs = [];

  RenderWrap get renderWrap {
    return wrapKey.currentContext?.findRenderObject() as RenderWrap;
  }

  bool get isDragging => dragChip != null;

  List<List<RenderBox>> _getWrapRuns(RenderWrap wrap) {
    //if (wrap.hasSize) {
    //freeWidth = runs.last.fold<double>(wrap.paintBounds.width, (width, chip) {
    //return width - chip.paintBounds.width - widget.field.widget.spacing;
    //});
    /*
      final parentData = lastChip.parentData as BoxParentData;
      final chipLeft = parentData.offset.dx;
      final translation = chip.getTransformTo(wrap).getTranslation();
      final chipLeft = translation.x;
      final wrapWidth = wrap.paintBounds.width;
      final chipWidth = lastChip.paintBounds.width;
      width = wrapWidth - chipLeft - chipWidth - widget.field.widget.spacing;
      */
    //} else {

    final runs = <List<RenderBox>>[];
    final chips = wrap.getChildrenAsList()..removeLast();
    int runIndex = 0;

    for (final chip in chips) {
      final prevChip = wrap.childBefore(chip);
      final offset = (chip.parentData as BoxParentData).offset;

      if (prevChip != null) {
        final prevOffset = (prevChip.parentData as BoxParentData).offset;
        if (prevOffset.dy == offset.dy) {
          runs[runIndex].add(chip);
        } else if (prevOffset.dy < offset.dy) {
          runIndex++;
          runs.add([chip]);
        }
      } else {
        runs.add([chip]);
      }
    }

    return runs;
  }

  bool _isLastInRun(String chipValue) {
    for (final run in runs) {
      if (widget.field.value!.indexOf(chipValue) ==
          renderWrap.getChildrenAsList().indexOf(run.last)) return true;
    }
    return false;
  }

  FastDraggableInputChip _buildChip(String chipValue) {
    final field = widget.field;
    return FastDraggableInputChip(
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
      onDragCompleted: () {
        setState(() => gapIndex = null);
      },
      onDraggableCanceled: (_v, _o) {
        setState(() {
          gapIndex = null;
        });
      },
      onDragStarted: () {
        setState(() {
          dragChip = chipValue;
        });
      },
      onDragEnd: (_details) {
        setState(() {
          dragX = null;
          dragChip = null;
        });
      },
      onDragUpdate: (details) {
        if (details.delta.dx != 0.0) {
          setState(() {
            dragX = details.delta.dx.round().clamp(dragRL, dragLR);
            //freeWidth = _getFreeWidth();
          });
        }
      },
      onMove: (details, targetChip) {
        //setState(() {
        //freeWidth = _getFreeWidth();
        //});
      },
    );
  }

  double _getFreeWidth() {
    final wrap = renderWrap;
    final chips = wrap.getChildrenAsList()..removeLast();
    final wrapWidth =
    wrap.hasSize ? wrap.paintBounds.width : wrap.constraints.maxWidth;

    if (chips.isNotEmpty) {
      double runExtent = 0.0;

      for (final chip in chips) {
        final width = chip.paintBounds.width + widget.field.widget.spacing;
        final isRunStart = chip == chips.first || runExtent + width > wrapWidth;

        runExtent = isRunStart ? width : runExtent + width;
      }
      return wrapWidth - runExtent;
    }

    return wrapWidth;
  }

  double _getTextFieldWidth() {
    final freeWidth = _getFreeWidth();
    final minWidth = widget.field.widget.fieldViewMinWidth;

    return minWidth > freeWidth ? double.infinity : freeWidth;
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.field;

    return Wrap(
      key: wrapKey,
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
        for (final chipValue in field.value!) _chipBuilder(chipValue, field),
        LayoutBuilder(
          builder: (_context, _constraints) {
            return SizedBox(
              width: _getTextFieldWidth(),
              child: TextFormField(
                controller: widget.textEditingController,
                //decoration: const InputDecoration(border: InputBorder.none),
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
            );
          },
        ),
        /*
        if (!isDragging)
          SizedBox(
            width: _getTextFieldWidth(),
            child: TextFormField(
              controller: widget.textEditingController,
              // decoration: const InputDecoration(border: InputBorder.none),
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
            builder: (context, constraints) {
              final width = _getFreeWidth();
              if (width != null) {
                return Container(
                  color: Colors.red,
                  width: width,
                  height: runs.last.last.paintBounds.height,
                  child: const Text('Remaining'),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
         */
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
