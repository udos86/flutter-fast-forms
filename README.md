# Flutter Fast Forms

[![CI](https://github.com/udos86/flutter-fast-forms/workflows/CI/badge.svg)](https://github.com/udos86/flutter-fast-forms/actions)
[![Pub Version](https://img.shields.io/pub/v/flutter_fast_forms)](https://pub.dev/packages/flutter_fast_forms)
[![codecov](https://codecov.io/gh/udos86/flutter-fast-forms/branch/master/graph/badge.svg)](https://codecov.io/gh/udos86/flutter-fast-forms)

Flutter Fast Forms is a Dart package for building Flutter forms fast.

At the core, it adds `FormField<T>` wrappers for all [Material](https://flutter.dev/docs/development/ui/widgets/material#Input%20and%20selections) / [Cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) input widgets **according** to the already built-in [TextFormField](https://api.flutter.dev/flutter/material/TextFormField-class.html) / [DropdownButtonFormField](https://api.flutter.dev/flutter/material/DropdownButtonFormField-class.html). 

At the top, it provides a convenient set of **adaptive** `FastFormControl<T>` widgets with support of [**validation states**](https://github.com/flutter/flutter/issues/18885).


## Adaptive Input Widgets

| adaptive<br>`FastFormControl<T>` |            adopts<br>Material           |                         adopts <br>Cupertino                         | requires <br>Material Widget ancestor<br>when `adaptive: true` |
|:--------------------------------:|:---------------------------------------:|:--------------------------------------------------------------------:|:--------------------------------------------------------------:|
|          `FastCheckbox`          |            `CheckboxListTile`           |                                  no                                  |                               yes                              |
|          `FastCalendar`          |           `CalendarDatePicker`          |                                  no                                  |                               yes                              |
|         `FastDatePicker`         |             `showDatePicker`            |                         `CupertinoDatePicker`                        |                               no                               |
|       `FastDateRangePicker`      |          `showDateRangePicker`          |                                  no                                  |                               yes                              |
|          `FastDropdown`          | `DropdownButtonFormField`<br>`<String>` |                                  no                                  |                               yes                              |
|         `FastRadioGroup`         |             `RadioListTile`             |                                  no                                  |                               yes                              |
|         `FastRangeSlider`        |              `RangeSlider`              |                                  no                                  |                               yes                              |
|      `FastSegmentedControl`      |                    no                   |                `SlidingSegmenteControl`<br>`<String>`                |                               no                               |
|           `FastSlider`           |            `Slider.adaptive`            |                           `CupertinoSlider`                          |                               no                               |
|           `FastSwitch`           |             `SwitchListTile`            |                           `CupertinoSwitch`                          |                               no                               |
|          `FastTextField`         |             `TextFormField`             |                      `CupertinoTextFormFieldRow`                     |                               no                               |
|         `FastTimePicker`         |             `showTimePicker`            | no / use `FastDatePicker`<br>with <br>`CupertinoDatePickerMode.time` |                               yes                              |
