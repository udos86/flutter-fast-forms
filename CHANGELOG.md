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
