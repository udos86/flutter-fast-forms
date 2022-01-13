import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../form_field.dart';

import 'autocomplete.dart';

typedef FastInputChipBuilder = Widget Function(
    String chip, FastInputChipsState field);

typedef FastInputChipsFieldViewBuilder = AutocompleteFieldViewBuilder Function(
    FastInputChipsState field);

typedef FastInputChipTextFieldViewBuilder = Widget Function(
    FastInputChipsState field,
    double freeSpace,
    void Function(String) onFieldSubmitted);

typedef FastInputWillAddChip = bool Function(
    String value, FastInputChipsState field);

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
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder,
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
    this.textFieldViewBuilder,
    this.textFieldViewMinWidth = 80.0,
    this.textFieldViewValidator,
    this.verticalDirection = VerticalDirection.down,
    this.willAddChip,
    this.wrap = true,
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
  final AutocompleteOptionToString<String> displayStringForOption;
  final FastInputChipsFieldViewBuilder? fieldViewBuilder;
  final AutocompleteOnSelected<String>? onSelected;
  final Iterable<String> options;
  final AutocompleteOptionsBuilder<String>? optionsBuilder;
  final FastAutocompleteWillAddOption<String>? optionsMatcher;
  final double optionsMaxHeight;
  final AutocompleteOptionsViewBuilder<String>? optionsViewBuilder;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final double spacing;
  final TextDirection? textDirection;
  final FastInputChipTextFieldViewBuilder? textFieldViewBuilder;
  final FormFieldValidator<String>? textFieldViewValidator;
  final double textFieldViewMinWidth;
  final VerticalDirection verticalDirection;
  final FastInputWillAddChip? willAddChip;
  final bool wrap;

  @override
  FastInputChipsState createState() => FastInputChipsState();
}

class FastInputChipsState extends FastFormFieldState<List<String>> {
  final scrollController = ScrollController();
  final textEditingController = TextEditingController();
  final textFocusNode = FocusNode();

  @override
  FastInputChips get widget => super.widget as FastInputChips;
}

Widget _chipBuilder(String chipValue, FastInputChipsState field) {
  return InputChip(
    label: Text(chipValue),
    isEnabled: field.widget.enabled,
    onDeleted: () => field.didChange([...field.value!]..remove(chipValue)),
  );
}

Widget _textFieldViewBuilder(FastInputChipsState field, double freeSpace,
    void Function(String) onFieldSubmitted) {
  final minWidth = field.widget.textFieldViewMinWidth;
  final baseWidth = field.widget.wrap ? double.infinity : minWidth;

  return SizedBox(
    width: minWidth > freeSpace ? baseWidth : freeSpace,
    child: TextFormField(
      controller: field.textEditingController,
      decoration: const InputDecoration(border: InputBorder.none),
      enabled: field.widget.enabled,
      focusNode: field.textFocusNode,
      maxLines: 1,
      onFieldSubmitted: onFieldSubmitted,
      validator: field.widget.textFieldViewValidator,
    ),
  );
}

class FastInputChipsView extends StatelessWidget {
  const FastInputChipsView({
    Key? key,
    required this.field,
    required this.onFieldSubmitted,
  }) : super(key: key);

  final FastInputChipsState field;
  final ValueChanged<String> onFieldSubmitted;

  double _getFreeNoWrapSpace(BuildContext context) {
    final root = context.findAncestorRenderObjectOfType<RenderConstrainedBox>();
    final list = context.findAncestorRenderObjectOfType<RenderSliverList>();

    assert(root != null && list != null);

    final children = <RenderBox>[];
    RenderBox? child = list!.firstChild;
    while (child != null) {
      children.add(child);
      child = list.childAfter(child);
    }

    final maxWidth =
        root!.hasSize ? root.size.width : root.constraints.maxWidth;
    final chips = children..removeLast();

    if (chips.isEmpty) return maxWidth;

    final axisExtent = chips.fold<double>(0.0, (extent, box) {
      return extent + box.paintBounds.width + field.widget.spacing;
    });

    return (maxWidth - axisExtent).clamp(0.0, double.infinity).toDouble();
  }

  double _getFreeWrapSpace(BuildContext context) {
    final wrap = context.findAncestorRenderObjectOfType<RenderWrap>();
    assert(wrap != null);

    final maxWidth =
        wrap!.hasSize ? wrap.size.width : wrap.constraints.maxWidth;
    final chips = wrap.getChildrenAsList()..removeLast();

    if (chips.isEmpty) return maxWidth;

    final runs = <List<RenderBox>>[];
    double runExtent = 0.0;

    for (final box in chips) {
      final width = box.size.width + field.widget.spacing;
      final isRunStart = box == chips.first || runExtent + width > maxWidth;

      if (isRunStart) {
        runs.add([box]);
        runExtent = width;
      } else {
        runs.last.add(box);
        runExtent = runExtent + width;
      }
    }

    return (maxWidth - runExtent).clamp(0.0, double.infinity).toDouble();
  }

  Widget _buildNoWrap(List<Widget> children) {
    return SizedBox(
      height: 48.0,
      child: ListView(
        controller: field.scrollController,
        scrollDirection: Axis.horizontal,
        children: children,
      ),
    );
  }

  Widget _buildWrap(List<Widget> children) {
    return Wrap(
      alignment: field.widget.alignment,
      clipBehavior: field.widget.clipBehavior,
      crossAxisAlignment: field.widget.crossAxisAlignment,
      direction: Axis.horizontal,
      spacing: field.widget.spacing,
      runAlignment: field.widget.runAlignment,
      runSpacing: field.widget.runSpacing,
      textDirection: field.widget.textDirection,
      verticalDirection: field.widget.verticalDirection,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chipBuilder = field.widget.chipBuilder ?? _chipBuilder;
    final textFieldViewBuilder =
        field.widget.textFieldViewBuilder ?? _textFieldViewBuilder;

    final chips = field.value!.map((chipValue) {
      final chip = chipBuilder(chipValue, field);
      return field.widget.wrap
          ? chip
          : Padding(
              child: chip,
              padding: EdgeInsetsDirectional.fromSTEB(
                  0, 0, field.widget.spacing, 0));
    });

    final children = [
      ...chips,
      LayoutBuilder(
        builder: (context, _constraints) {
          final freeSpace = field.widget.wrap
              ? _getFreeWrapSpace(context)
              : _getFreeNoWrapSpace(context);
          return textFieldViewBuilder(field, freeSpace, onFieldSubmitted);
        },
      ),
    ];

    return field.widget.wrap ? _buildWrap(children) : _buildNoWrap(children);
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

bool _willAddChip(String? chip, FastInputChipsState field) {
  return chip != null && !field.value!.contains(chip);
}

ValueChanged<String> _onFieldSubmitted(
    FastInputChipsState field, VoidCallback? onFieldSubmitted) {
  return (String value) {
    if (value.isEmpty) {
      field.textFocusNode.unfocus();
    } else {
      onFieldSubmitted?.call();
      final willAddChip = field.widget.willAddChip ?? _willAddChip;
      if (willAddChip(value, field)) {
        field.didChange([...field.value!, value]);
        field.textEditingController.clear();

        if (field.widget.wrap) {
          field.textFocusNode.requestFocus();
        } else {
          WidgetsBinding.instance?.addPostFrameCallback(
            (_duration) {
              if (field.scrollController.hasClients) {
                field.textFocusNode.requestFocus();
                field.scrollController.animateTo(
                    field.scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut);
              }
            },
          );
        }
      }
    }
  };
}

AutocompleteFieldViewBuilder _fieldViewBuilder(FastInputChipsState field) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return FastInputChipsView(
      field: field,
      onFieldSubmitted: _onFieldSubmitted(field, onFieldSubmitted),
    );
  };
}

Widget inputChipsBuilder(FormFieldState<List<String>> field) {
  field as FastInputChipsState;
  final widget = field.widget;
  final fieldViewBuilder = widget.fieldViewBuilder ?? _fieldViewBuilder;

  return GestureDetector(
    onTap: widget.enabled ? () => field.textFocusNode.requestFocus() : null,
    child: InputDecorator(
      decoration: field.decoration.copyWith(
        contentPadding: widget.contentPadding,
        errorText: field.errorText,
      ),
      child: RawAutocomplete<String>(
        displayStringForOption: widget.displayStringForOption,
        fieldViewBuilder: fieldViewBuilder(field),
        focusNode: field.textFocusNode,
        onSelected: _onFieldSubmitted(field, null),
        optionsBuilder: _optionsBuilder(widget.options, field),
        optionsViewBuilder:
            widget.optionsViewBuilder ?? _optionsViewBuilder(field),
        textEditingController: field.textEditingController,
      ),
    ),
  );
}
