## [16.0.0] - 05/15/2024

* upgrades to Flutter `3.22.0`
* replaces deprecated `MaterialStateProperty<T>` type with `WidgetStateProperty<T>`
* adds `avatarBoxConstraints` to `FastChoice Chip`
* adds `cursorErrorColor` and `onTapAlwaysCalled` properties to `FastTextField`

## [15.0.0] - 01/08/2024

* upgrades to Flutter `3.16.5`
* adds new feature **Conditional Form Fields**
  * adds `conditions` property to `FastFormField`
  * adds `FastCondition`, `FastConditionList` classes
  * adds `FastConditionMatch` enum
  * adds `FastConditionHandler` and `FastConditionTest` typedefs
  * adds `testConditions` function to `FastformFieldState`
* adds new `FastSegmentendButton` that wraps Material [`SegmentedButton`](https://api.flutter.dev/flutter/material/SegmentedButton-class.html?gclid=CjwKCAiAs6-sBhBmEiwA1Nl8s5c8wRhB056CtAeuZP1-m_XUYi-jYGrVMh1lMnkwRmvKwlTelErtixoCAS4QAvD_BwE&gclsrc=aw.ds)
* adds `showInputDecoration` property to `FastCheckbox`, `FastSwitch`, `FastCalendar`, `FastChoiceChips`, `FastRadioGroup`, `FastRangeSlider` and `FastSlider`
* adds `canPop` and `onPopInvoked` properties to `FastForm`
* adds `cupertinoErrorBuilder`, `cupertinoHelperBuilder` and `cupertinoPrefixBuilder` properties to `FastCheckbox`, `FastSwitch`, `FastDatePicker`, `FastSegmentendControl` and `FastSlider`
* deprecates `errorBuilder` and `helperBuilder` on `FastCheckbox`, `FastSwitch`, `FastDatePicker`, `FastSegmentendControl` and `FastSlider`
* changes value type of `FastChoiceChips` from `List<T>` to `Set<T>`
* removes `errorBuilder` and `helperBuilder` default functions
* adds `cupertinoErrorBuilder`, `cupertinoHelperBuilder` and `cupertinoPrefixBuilder` default functions
* adds generic `FastWidgetBuilder` typedef 
* replaces `FastCheckboxTitleBuilder` with `FastCheckboxWidgetBuilder` typedef
* replaces `FastSwitchTitleBuilder` with `FastCheckboxWidgetBuilder` typedef
* replaces `FastRangeSliderPrefixBuilder` and `FastRangeSliderSuffixBuilder` with `FastRangeSliderWidgetBuilder` typedef
* replaces `FastSliderPrefixBuilder` and `FastSliderSuffixBuilder` with `FastSliderWidgetBuilder` typedef
* adds `FastDatePickerWidgetBuilder` typedef
* fixes generic typing in `FastChoiceChips` and `FastSegmentedControl`
* fixes hard-coded text colors in `checkboxTitleBuilder` and `switchTitleBuilder`

## [14.1.0] - 12/18/2023

* upgrades to Flutter `3.16.4`
* adds dartdoc comments
* adds Dart Patterns code refactoring
* adds `autovalidateOnTouched` property to `FastTextField`
* fix: `autovalidateMode` now works on `FastTextField`
* fix: `optionsBuilder` now works on `FastChipsInput`

## [14.0.0] - 12/12/2023

* upgrades to Flutter `3.16.3`
* upgrades to intl `0.19.0.`
* adds internal `Validators` refactoring
* adds documentation

## [13.0.0] - 12/02/2023

* upgrades to Flutter `3.16.2`
* upgrades to Dart `3.2.0`
* removes deprecated `text` property from `FastRadioOption<T>`
* adds `offLabelColor` and `onLabelColor` properties to `FastSwitch`
* adds `barrierColor`, `barrierDismissible` and `barrierLabel` properties to `FastDatePicker`, `FastDateRangePicker` and `FastTimePicker`
* adds `optionsViewOpenDirection` property to `FastAutocomplete`
* adds `checkmarkColor` and `showCheckmark` properties to `FastChoiceChip`
* adds `showCheckmark` property to `FastChoiceChips`
* adds `canRequestFocus`, `clipBehavior`, `contentInsertionConfiguration`, `cursorOpacityAnimates`, 
`dragStartBehavior`, `onAppPrivateCommand`, `scribbleEnabled`, `scrollController`, 
`selectionHeightStyle`, `selectionWidthStyle` and `undoController` properties to `FastTextField`

## [12.0.0] - 08/22/2023

* upgrades to Flutter `3.13.0`
* upgrades to Dart `3.1.0`
* adds `checkboxSemanticLabel` properties to `FastCheckbox`
* sets `autofocus`, `focusNode` and `onFocusChange` on `CupertinoSwitch` in `FastSwitch`,
* adds `switchToCalendarEntryModeIcon` and `switchToInputEntryModeIcon` properties to `FastDatePicker` and `FastDateRangePicker`
* adds `color` property to `FastChoiceChip`
* adds `allowedInteraction` property to `FastSlider`

## [11.1.0] - 06/25/2023

* `text` property on `FastRadioOption` is now deprecated
* adds `isThreeLine`, `secondary`, `selected`. `subtitle`, `title` and `visualDensity` properties to `FastRadioOption`
* adds `activeColor`, `controlAffinity`, `fillColor`, `hoverColor`, `materialTapTargetSize`, `mouseCursor`,
`overlayColor`, `selectedTileColor`, `shapeBorder`, `splashRadius`, `tileColor` and `toggleable` properties to `FastRadioGroup`
* adds `isError` and `onFocus` properties to `FastCheckbox`
* adds `onActiveThumbImageError`, `onFocusChange` and `onInactiveThumbImageError` properties to `FastSwitch`
* adds `showDayOfWeek` property to `FastDatePicker`
* adds `keyboardType` property to `FastDateRangePicker`
* adds `orientation` property to `FastTimePicker`
* adds `onChangeEnd`, `onChangeStart` and `semanticFormatterCallback` properties to `FastRangeSlider`
* adds `onChanged` property to `FastSlider`
* adds `magnifierConfiguration`, `onTapOutside` and `spellCheckConfiguration` properties to `FastTextField`

## [11.0.0] - 05/16/2023

* upgrades to Flutter `3.10.0`
* upgrades to Dart `3.0.0`
* upgrades sample to Material 3
* adds adaptiveness to `FastCheckbox` via `CupertinoCheckbox`
* adds all new styling properties to `FastCheckbox`, `FastRangeSlider`, `FastSlider` and `FastSwitch`
* adds `textStyle` property to all date time fields
* adds `inputDecorationTheme` property to `FastForm`
* fixes styling issues when `enabled: false`  
* fixes incorrect default content padding on iOS

**Breaking Changes**

* reduces the default `InputDecoration` of `FastFormField<T>`

**old**
```dart
InputDecoration(
  contentPadding: widget.contentPadding,
  errorText: field.errorText,
  helperText: widget.helperText,
  labelText: widget.labelText,
  labelStyle: TextStyle(
    color: field.enabled
      ? theme.textTheme.bodyLarge!.color
      : theme.disabledColor,
  ),
  enabled: field.enabled,
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: theme.disabledColor, width: 1),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: theme.primaryColor, width: 2),
  ),
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red[500]!, width: 2),
  ),
  filled: false,
  fillColor: Colors.white,
);
```

**new**
```dart
InputDecoration(
  contentPadding: widget.contentPadding ?? const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
  enabled: enabled,
  errorText: errorText, 
  helperText: widget.helperText,
  labelText: widget.labelText,
);
```
For any further styling now use `inputDecorationTheme` or `inputDecorationBuilder` properties 
of `FastForm` (see example app).

* renames `decorator` property on `FastForm` to `inputDecorationBuilder` and changes its typedef

**old**
```dart
typedef FastInputDecorator = InputDecoration Function(ThemeData theme, FastFormFieldState field);
```

**new**
```dart
typedef FastInputDecorationBuilder = InputDecoration Function(FastFormFieldState field);
```
For retrieving `ThemeData` now use `Theme.of(context)` within the function body.

## [10.0.0] - 01/29/2023

* upgrades to Flutter `3.7.0`
* minimum Dart SDK now is `2.19.0`
* removes `toolbarOptions` property from `FastTextField`
* adds `contextMenuBuilder` property to `FastTextField`

## [9.0.1] - 01/24/2023

* upgrades `intl`to `0.18.0`

## [9.0.0] - 11/04/2022

* `FastChipsInput` now supports removal of single chips via backspace according to Material Design spec
* adds `chipIndex` parameter to `FastChipsInputChipBuilder` 

## [8.1.0] - 30/10/2022

* adds compatibility for Flutter `3.3.5`
* adds `mouseCursor`, `onFieldSubmitted`, `onEditingComplete` and `onTap` to `FastTextField`

## [8.0.0] - 03/09/2022

* adds compatibility for Flutter `3.3.0`
* adds `reorderable` property to `FastFormArray`
* renames `FastInputChips` to `FastChipsInput` 
* removes `reorderableFormArrayBuilder` 

## [7.2.1] - 06/12/2022

* resets `FastFormArray` properly 

## [7.2.0] - 06/11/2022

* adds new `FastFormArray` widget (see [example](https://github.com/udos86/flutter-fast-forms/blob/master/example/lib/main.dart#L120) for usage and implementing [`FastFormArray` items](https://github.com/udos86/flutter-fast-forms/blob/master/example/lib/form_array_item.dart))

## [7.1.0] - 06/04/2022

* adds missing properties to `FastFormField` widgets
* uses `defaultTargetPlatform` instead of `Theme.of(context).platform`
* improves typing

## [7.0.0] - 05/13/2022

* update to Flutter `3.0.0` and Dart `2.17.0`
* removes `autofocus` property from `FastFormField`
* adds `autofocus` property to `FastCheckbox`, `FastSwitch`, `FastDropdown`, `FastChoiceChips`, `FastSlider` and `FastTextField`
* uses Dart `2.17.0` super-initializer parameters now wherever possible

## [6.0.0] - 04/24/2022

* `onChanged` now works on any `FastFormField`

## [5.0.0] - 02/04/2022

* widgets now correctly expose `contentPadding` property
* renames `label` property of `FastFormField` to `labelText`
* renames `title` property of `FastCheckbox` to `titleText`
* renames `willAddOption` property of `FastAutocomplete` to `willDisplayOption`
* renames `optionsMatcher` property of `FastInputChips` to `willDisplayOption`
* renames `updateValues()` method of `FastFormState` to `onChanged()`
* removes `name` getter from `FastFormField`
* moves `static FastFormState? of(BuildContext context)` to `FastForm`
* adds `form` getter to `FastFormFieldState`
* simplifies creation of `InputDecoration` via `decoration` getter of `FastFormFieldState`   
* `_FastFormScope` now follows internal `_FormScope`

## [4.0.1] - 01/18/2022

* fixes bug in `FastInputChips` wrap run extent calculation

## [4.0.0] - 01/14/2022

* `FastChoiceChips` now exposes its value as `List<String>`
* `FastInputChips` can now scroll horizontally via `wrap` property
* renames `optionsMatcher` property of `FastAutocomplete` to `willAddOption`
* `FastFormFieldState<T>` is now `abstract` and its widget getter `@protected`

## [3.0.0] - 01/03/2022

* renames `id` property of `FastFormField` to `name`
* improves `FastInputChips`
* adds Dart `2.15` tear-offs

## [2.1.0] - 11/17/2021

* introduces `FastInputChips`

## [2.0.0] - 10/24/2021

* introduces typed validators
* prefixes typedefs with `Fast`
* improves typing of option form fields
* removes `builders`config from `FormScope` 

## [v1.1.0] - 10/16/2021

* introduces `FastAutocomplete<T>` widget
* introduces `FastChoiceChips` widget

## [v1.0.1] - 10/14/2021

* internal `FastFormFieldState<T>` refactoring

## [v1.0.0] - 10/13/2021

* migration to Flutter `2.5`

## [v0.9.0] - 03/21/2021

* removes `mask_text_input_formatter` dependency

## [v0.9.0-nullsafety.2] - 03/06/2021

* resets Flutter SDK version to 2.0.0

## [v0.9.0-nullsafety.1] - 03/06/2021

* migration to Flutter 2.0.1

## [v0.8.0-nullsafety.1] - 12/31/2020

* adaptive form controls

## [v0.7.0-nullsafety.1] - 12/29/2020

* migration to null safety

## [v0.6.0] - 12/28/2020

* rewrite of `FastFormState`

## [v0.5.0] - 12/27/2020

* pre-release

## [v0.1.0] - 08/12/2020

* beta release

## [v0.0.1] - 07/30/2020

* initial release
