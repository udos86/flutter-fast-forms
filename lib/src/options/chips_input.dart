import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../form.dart';

/// Utility class for safely integrating the zero-width unicode character in
/// editable text in order to detect delete actions as proposed by Matt Carroll.
///
/// see https://medium.com/super-declarative/why-you-cant-detect-a-delete-action-in-an-empty-flutter-text-field-3cf53e47b631
abstract class Zwsp {
  static const raw = '\u200b';

  static String strip(String text) => text.replaceAll(raw, '');

  static TextEditingValue value() {
    const selection = TextSelection.collapsed(offset: raw.length);
    return const TextEditingValue(text: raw, selection: selection);
  }
}

typedef FastChipsInputChipBuilder = Widget Function(
    String chipValue, int chipIndex, FastChipsInputState field);

typedef FastChipsInputFieldViewBuilder = AutocompleteFieldViewBuilder Function(
    FastChipsInputState field);

typedef FastChipsInputTextFieldViewBuilder = Widget Function(
    FastChipsInputState field,
    double freeSpace,
    void Function(String) onFieldSubmitted);

typedef FastChipsInputWillDisplayOption = bool Function(
    String text, String option, FastChipsInputState field);

typedef FastChipsInputWillAddChip = bool Function(
    String value, FastChipsInputState field);

/// A [FastFormField] that contains a Material chips input.
@immutable
class FastChipsInput extends FastFormField<List<String>> {
  const FastChipsInput({
    super.autovalidateMode,
    super.builder = chipsInputBuilder,
    super.conditions,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue = const <String>[],
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.onTouched,
    super.restorationId,
    super.validator,
    this.alignment = WrapAlignment.start,
    this.chipBuilder = _chipBuilder,
    this.clipBehavior = Clip.none,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder,
    this.onSelected,
    this.options = const [],
    this.optionsBuilder,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.spacing = 8.0,
    this.textDirection,
    this.textFieldViewBuilder = _textFieldViewBuilder,
    this.textFieldViewMinWidth = 80.0,
    this.textFieldViewValidator,
    this.verticalDirection = VerticalDirection.down,
    this.willAddChip = _willAddChip,
    this.willDisplayOption = _willDisplayOption,
    this.wrap = true,
  });

  final WrapAlignment alignment;
  final FastChipsInputChipBuilder chipBuilder;
  final Clip clipBehavior;
  final WrapCrossAlignment crossAxisAlignment;
  final AutocompleteOptionToString<String> displayStringForOption;
  final FastChipsInputFieldViewBuilder? fieldViewBuilder;
  final AutocompleteOnSelected<String>? onSelected;
  final Iterable<String> options;
  final AutocompleteOptionsBuilder<String>? optionsBuilder;
  final double optionsMaxHeight;
  final AutocompleteOptionsViewBuilder<String>? optionsViewBuilder;
  final OptionsViewOpenDirection optionsViewOpenDirection;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final double spacing;
  final TextDirection? textDirection;
  final FastChipsInputTextFieldViewBuilder textFieldViewBuilder;
  final FormFieldValidator<String>? textFieldViewValidator;
  final double textFieldViewMinWidth;
  final VerticalDirection verticalDirection;
  final FastChipsInputWillAddChip willAddChip;
  final FastChipsInputWillDisplayOption willDisplayOption;
  final bool wrap;

  @override
  FastChipsInputState createState() => FastChipsInputState();
}

/// State associated with a [FastChipsInput] widget.
class FastChipsInputState extends FastFormFieldState<List<String>> {
  final scrollController = ScrollController();
  final textFieldController = TextEditingController(text: Zwsp.raw);
  final textFieldFocusNode = FocusNode();
  final textFieldKeyboardFocusNode = FocusNode();
  final hiddenTextFieldFocusNode = FocusNode();

  /// Indicates that backspace was pressed on an already via backspace selected
  /// chip.
  bool backspaceRemove = false;

  /// Stores the index of the via backspace selected chip.
  int? selectedChipIndex;

  @override
  FastChipsInput get widget => super.widget as FastChipsInput;

  @override
  void initState() {
    super.initState();
    textFieldController.addListener(_onTextFieldChanged);
    textFieldFocusNode.addListener(_onTextFieldFocusChanged);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textFieldController.dispose();
    textFieldFocusNode.dispose();
    textFieldKeyboardFocusNode.dispose();
    hiddenTextFieldFocusNode.dispose();
  }

  String get text => textFieldController.value.text;

  void onKeyPressed(KeyEvent keyEvent) {
    final isBackspaceUp = keyEvent is KeyUpEvent &&
        keyEvent.logicalKey == LogicalKeyboardKey.backspace;

    if (isBackspaceUp && text.isEmpty) {
      if (backspaceRemove) {
        didChange([...value!]..remove(value![selectedChipIndex!]));
        setState(() {
          selectedChipIndex =
              selectedChipIndex! > 0 ? selectedChipIndex! - 1 : null;
        });
      } else {
        setState(() => backspaceRemove = true);
      }
    }
  }

  void _onTextFieldChanged() {
    /// Whenever backspace was pressed removing the zwsp character and the chips
    /// input contains at least one chip select the chip next to the text field.
    if (value!.isNotEmpty && text.isEmpty) {
      textFieldFocusNode.unfocus();
      hiddenTextFieldFocusNode.requestFocus();
      setState(() {
        selectedChipIndex = value!.indexOf(value!.last);
      });
    } else {
      setState(() {
        backspaceRemove = false;
        selectedChipIndex = null;
      });
    }

    /// Whenever new text is entered again after a chip was removed via
    /// backspace add zwsp in front of it.
    if (text.length == 1 && text != Zwsp.raw) {
      final textWithZwsp = Zwsp.raw + text;
      final selection = TextSelection.collapsed(offset: textWithZwsp.length);

      textFieldController.text = textWithZwsp;
      textFieldController.selection = selection;

      setState(() => backspaceRemove = false);
    }
  }

  void _onTextFieldFocusChanged() {
    if (textFieldFocusNode.hasFocus) {
      if (text.isEmpty) {
        textFieldController.value = Zwsp.value();
      }
      setState(() {
        selectedChipIndex = null;
        backspaceRemove = false;
      });
    } else {
      wasTouched();
    }
  }
}

/// A [FastChipsInputChipBuilder] that is the default
/// [FastChipsInput.chipBuilder].
///
/// Returns an [InputChip].
Widget _chipBuilder(
    String chipValue, int chipIndex, FastChipsInputState field) {
  final FastChipsInputState(:enabled, :selectedChipIndex, :value!) = field;

  return InputChip(
    label: Text(chipValue),
    isEnabled: enabled,
    onDeleted: () => field.didChange([...value]..remove(chipValue)),
    selected: chipIndex == selectedChipIndex,
    showCheckmark: false,
  );
}

/// A [FastChipsInputTextFieldViewBuilder] that is the default
/// [FastChipsInput.textFieldViewBuilder].
///
/// Returns a nested [TextFormField] where new chip values
/// are entered by the user.
Widget _textFieldViewBuilder(FastChipsInputState field, double freeSpace,
    void Function(String) onFieldSubmitted) {
  final FastChipsInputState(
    :enabled,
    :hiddenTextFieldFocusNode,
    :onKeyPressed,
    :textFieldController,
    :textFieldFocusNode,
    :textFieldKeyboardFocusNode,
    :widget
  ) = field;
  final minWidth = widget.textFieldViewMinWidth;
  final baseWidth = widget.wrap ? double.infinity : minWidth;

  return SizedBox(
    width: minWidth > freeSpace ? baseWidth : freeSpace,
    child: KeyboardListener(
      focusNode: textFieldKeyboardFocusNode,
      onKeyEvent: onKeyPressed,
      child: Stack(
        children: [
          /// A hidden text field is needed to keep the keyboard open whenever a
          /// chip is selected for removal via backspace.
          SizedBox(
            height: 0,
            width: 0,
            child: Baseline(
              baseline: 0,
              baselineType: TextBaseline.alphabetic,
              child: TextFormField(
                focusNode: hiddenTextFieldFocusNode,
              ),
            ),
          ),
          TextFormField(
            controller: textFieldController,
            decoration: const InputDecoration(border: InputBorder.none),
            enabled: enabled,
            focusNode: textFieldFocusNode,
            maxLines: 1,
            onFieldSubmitted: onFieldSubmitted,
            validator: widget.textFieldViewValidator,
          ),
        ],
      ),
    ),
  );
}

/// A field view widget.
class FastChipsInputView extends StatelessWidget {
  const FastChipsInputView({
    super.key,
    required this.field,
    required this.onFieldSubmitted,
  });

  final FastChipsInputState field;
  final ValueChanged<String> onFieldSubmitted;

  /// Calculates the free space on the horizontal axis of a [ListView].
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

  /// Calculates the free space in the last run of a [Wrap].
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
      final width = box.size.width;
      final extent = width + field.widget.spacing;
      final isRunStart = box == chips.first || runExtent + width > maxWidth;

      if (isRunStart) {
        runs.add([box]);
        runExtent = extent;
      } else {
        runs.last.add(box);
        runExtent = runExtent + extent;
      }
    }

    return (maxWidth - runExtent).clamp(0.0, double.infinity).toDouble();
  }

  /// Returns a [SizedBox] with a child [ListView] that contains all [children]
  /// in horizontal direction.
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

  /// Returns a [Wrap] that contains all [children].
  Widget _buildWrap(List<Widget> children) {
    final FastChipsInputState(:widget) = field;

    return Wrap(
      alignment: widget.alignment,
      clipBehavior: widget.clipBehavior,
      crossAxisAlignment: widget.crossAxisAlignment,
      direction: Axis.horizontal,
      spacing: widget.spacing,
      runAlignment: widget.runAlignment,
      runSpacing: widget.runSpacing,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      children: children,
    );
  }

  /// Returns either a [Wrap] or a horizontal [ListView] that contains a [List]
  /// of chips and an [Autocomplete].
  ///
  /// Uses [_buildWrap] and [_getFreeWrapSpace] when [FastChipsInput.wrap] is
  /// `true`.
  ///
  /// Uses [_buildNoWrap] and [_getFreeNoWrapSpace] when [FastChipsInput.wrap]
  /// is `false`.
  @override
  Widget build(BuildContext context) {
    final FastChipsInputState(:value!, :widget) = field;
    final chips = value.asMap().entries.map((entry) {
      final index = entry.key;
      final chipValue = entry.value;
      final chip = widget.chipBuilder(chipValue, index, field);
      return widget.wrap
          ? chip
          : Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, widget.spacing, 0),
              child: chip,
            );
    });

    final children = [
      ...chips,
      LayoutBuilder(
        builder: (context, constraints) {
          final space = widget.wrap
              ? _getFreeWrapSpace(context)
              : _getFreeNoWrapSpace(context);
          return widget.textFieldViewBuilder(field, space, onFieldSubmitted);
        },
      ),
    ];

    return widget.wrap ? _buildWrap(children) : _buildNoWrap(children);
  }
}

/// A [FastChipsInputWillAddOption] that is the default
/// [FastChipsInput.willAddOption].
///
/// Returns whether an option is to be shown.
bool _willDisplayOption(String text, String option, FastChipsInputState field) {
  return field.value!.contains(option)
      ? false
      : option.toLowerCase().contains(text.toLowerCase());
}

/// Returns an [AutocompleteOptionsBuilder].
///
/// Uses [FastChipsInput.willDisplayOption].
AutocompleteOptionsBuilder<String> _optionsBuilder(
    Iterable<String> options, FastChipsInputState field) {
  final FastChipsInputState(:widget) = field;

  return (TextEditingValue value) {
    final text = Zwsp.strip(value.text);
    if (text.isEmpty) {
      return const Iterable.empty();
    }
    return options
        .where((option) => widget.willDisplayOption(text, option, field));
  };
}

/// Returns an [AutocompleteOptionsViewBuilder].
///
/// Contains a reimplementation of the default
/// [Autocomplete.optionsViewBuilder].
AutocompleteOptionsViewBuilder<String> _optionsViewBuilder(
    FastChipsInputState field) {
  return (BuildContext context, AutocompleteOnSelected<String> onSelected,
      Iterable<String> options) {
    final FastChipsInputState(:widget) = field;

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
                    SchedulerBinding.instance
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

/// A [FastChipsInputWillDisplayOption] that is the default
/// [FastChipsInput.willDisplayOption].
///
/// Returns whether a new chip should be added.
bool _willAddChip(String? chip, FastChipsInputState field) {
  return chip != null && !field.value!.contains(chip);
}

/// Returns a [ValueChanged] callback that updates the
/// [FastChipsInputState.value].
///
ValueChanged<String> _onFieldSubmitted(
    FastChipsInputState field, bool onSelected,
    [VoidCallback? onFieldSubmitted]) {
  return (String value) {
    final FastChipsInputState(
      :didChange,
      :scrollController,
      :textFieldController,
      :textFieldFocusNode,
      :widget
    ) = field;

    if (value == Zwsp.raw) {
      textFieldFocusNode.unfocus();
    } else {
      final text = Zwsp.strip(value);
      final isOption = widget.options
          .any((option) => widget.willDisplayOption(text, option, field));

      /// Selecting an option via keyboard instead of tap requires the field
      /// view onFieldSubmitted callback to be called manually. Otherwise
      /// onSelected would not be called on RawAutocomplete leading to the
      /// current editing value being added instead of the selected option.
      /// This is a costly but necessary workaround due to the way
      /// RawAutocomplete is implemented.
      if (!onSelected && isOption) {
        onFieldSubmitted?.call();
      } else {
        if (widget.willAddChip(text, field)) {
          didChange([...field.value!, text]);
          textFieldController.value = Zwsp.value();

          if (widget.wrap) {
            textFieldFocusNode.requestFocus();
          } else {
            WidgetsBinding.instance.addPostFrameCallback(
              (duration) {
                if (scrollController.hasClients) {
                  textFieldFocusNode.requestFocus();
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                }
              },
            );
          }
        }
      }
    }
  };
}

/// A [FastChipsInputFieldViewBuilder] that is the default
/// [FastChipsInput.fieldViewBuilder].
///
/// Returns an [AutocompleteFieldViewBuilder] function that returns a
/// [FastChipsInputView].
AutocompleteFieldViewBuilder _fieldViewBuilder(FastChipsInputState field) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return FastChipsInputView(
      field: field,
      onFieldSubmitted: _onFieldSubmitted(field, false, onFieldSubmitted),
    );
  };
}

/// A [FormFieldBuilder] that is the default [FastChipsInput.builder].
///
/// Returns an [InputDecorator] inside a [GestureDetector] that contains a
/// [RawAutocomplete] on any [TargetPlatform].
///
/// Uses [FastChipsInput.fieldViewBuilder] to create the
/// [RawAutocomplete.fieldViewBuilder].
///
/// Uses [FastChipsInput.optionsViewBuilder] to create the
/// [RawAutocomplete.optionsViewBuilder].
///
/// Uses [_onFieldSubmitted] to create the [RawAutocomplete.onSelected]
/// callback.
///
/// Uses [FastChipsInput.optionsBuilder] or [_optionsBuilder] to create the
/// [RawAutocomplete.optionsBuilder].
Widget chipsInputBuilder(FormFieldState<List<String>> field) {
  field as FastChipsInputState;
  final FastChipsInputState(
    :decoration,
    :enabled,
    :textFieldController,
    :textFieldFocusNode,
    :widget
  ) = field;
  final fieldViewBuilder = widget.fieldViewBuilder ?? _fieldViewBuilder;

  return GestureDetector(
    onTap: enabled ? () => textFieldFocusNode.requestFocus() : null,
    child: InputDecorator(
      decoration: decoration,
      child: RawAutocomplete<String>(
        displayStringForOption: widget.displayStringForOption,
        fieldViewBuilder: fieldViewBuilder(field),
        focusNode: textFieldFocusNode,
        onSelected: _onFieldSubmitted(field, true),
        optionsViewOpenDirection: widget.optionsViewOpenDirection,
        optionsBuilder:
            widget.optionsBuilder ?? _optionsBuilder(widget.options, field),
        optionsViewBuilder:
            widget.optionsViewBuilder ?? _optionsViewBuilder(field),
        textEditingController: textFieldController,
      ),
    ),
  );
}
