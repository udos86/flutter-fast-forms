# Flutter Fast Forms

[![CI](https://github.com/udos86/flutter-fast-forms/workflows/CI/badge.svg)](https://github.com/udos86/flutter-fast-forms/actions)
[![Pub Version](https://img.shields.io/pub/v/flutter_fast_forms)](https://pub.dev/packages/flutter_fast_forms)
[![codecov](https://codecov.io/gh/udos86/flutter-fast-forms/branch/master/graph/badge.svg)](https://codecov.io/gh/udos86/flutter-fast-forms)

Flutter Fast Forms is the only Dart package you need to build Flutter forms fast.

It adds these missing features to the Flutter SDK: 

* `FastFormControl<T>` convenience widgets that wrap [Material](https://flutter.dev/docs/development/ui/widgets/material#Input%20and%20selections) / [Cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) form controls in a `FormField<T>` **according** to the already built-in [`TextFormField`](https://api.flutter.dev/flutter/material/TextFormField-class.html) / [`DropdownButtonFormField`](https://api.flutter.dev/flutter/material/DropdownButtonFormField-class.html) 
* `FastForm` widget that wraps the built-in `Form` widget for providing the current form field values in `onChanged` callback
* `FastFormArray` widget that aggregates a flexible number of homogeneous controls in a single `FormField<T>`
* `FastChipsInput` widget that converts text input into chips as defined by [Material Design](https://material.io/components/chips#input-chips)  
* Conditional form fields
* `touched` [**validation state**](https://github.com/flutter/flutter/issues/18885)
* Common `FormFieldValidator<T>` functions

<br/>

<img src="https://github.com/udos86/flutter-fast-forms/assets/508325/13708c6d-ac19-4101-bb3a-2ef6fb6a8f54" width="200" 
/><img src="https://github.com/udos86/flutter-fast-forms/assets/508325/a5537d99-4eba-46ae-a716-d4623d88b714" width="200"
/><img src="https://github.com/udos86/flutter-fast-forms/assets/508325/7855459f-d872-4524-8c29-0271e7f9630f" width="200"
/><img src="https://github.com/udos86/flutter-fast-forms/assets/508325/efe8f17f-149a-4e99-aaa5-59ce7172ccfc" width="200"/> 

<img src="https://user-images.githubusercontent.com/508325/137577735-9733ebc2-d7e3-4566-b68f-b8cfbfb373ca.png" width="200"
/><img src="https://user-images.githubusercontent.com/508325/137577821-454f9bb8-aaf2-4dc5-82e4-c7d70b04f426.png" width="200"
/><img src="https://user-images.githubusercontent.com/508325/137577765-078ab415-8de3-4ad1-aa87-947603b8279b.png" width="200"/> 

## Table of Contents

- [Getting Started](#getting-started)
- [Widget Catalog](#widget-catalog)
- [Adaptive Form Fields](#adaptive-form-fields)
- [Conditional Form Fields](#conditional-form-fields)
- [Custom Form Fields](#custom-form-fields)

<br/>

## Getting Started

**1.** Add a `FastForm` to your widget tree:
```dart
class MyFormPage extends StatelessWidget {
  MyFormPage({Key? key, required this.title}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FastForm(
            formKey: formKey,
            children: [],
          ),
        ),
      ),
    );
  }
}
```

**2.** Add `FastFormControl<T>` children to the `FastForm`:
```dart
FastForm(
  formKey: formKey,
  children: [
    const FastTextField(
      name: 'field_destination',
      labelText: 'Destination',
      placeholder: 'Where are you going?',
    ),
    FastDateRangePicker(
      name: 'field_check_in_out',
      labelText: 'Check-in - Check-out',
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ),
    const FastCheckbox(
      name: 'field_travel_purpose',
      labelText: 'Travel purpose',
      titleText: 'I am travelling for work',
    ),
  ],
),
```

**3.** Wrap the children in a `FastFormSection` for visual grouping and consistent padding:
```dart
FastForm(
  formKey: formKey,
  children: [
    FastFormSection(
      header: const Text('My Form'),
      padding: EdgeInsets.all(16.0),
      children: [
        const FastTextField(
          name: 'field_destination',
          labelText: 'Destination',
          placeholder: 'Where are you going?',
        ),
        // ...
      ],
    ),
  ]
),
```


## Widget Catalog

|       `FastFormControl<T>`       | field value type |          wraps Material widget          |           wraps Cupertino widget<br> when `adaptive: true`           |
|:--------------------------------:|:----------------:|:---------------------------------------:|:--------------------------------------------------------------------:|
|      `FastAutocomplete<O>`       |     `String`     |            `Autocomplete<O>`            |                                  no                                  |
|          `FastCheckbox`          |      `bool`      |           `CheckboxListTile`            |                         `CupertinoCheckbox`                          |
|       `FastChoiceChips<T>`       |     `Set<T>`     |              `ChoiceChip`               |                                  no                                  |
|          `FastCalendar`          |    `DateTime`    |          `CalendarDatePicker`           |                                  no                                  |
|         `FastChipsInput`         |  `List<String>`  | `RawAutocomplete<String>` + `InputChip` |                                  no                                  |
|         `FastDatePicker`         |    `DateTime`    |            `showDatePicker`             |                        `CupertinoDatePicker`                         |
|      `FastDateRangePicker`       | `DateTimeRange`  |          `showDateRangePicker`          |                                  no                                  |
|        `FastDropdown<T>`         |       `T`        |      `DropdownButtonFormField<T>`       |                                  no                                  |
|       `FastRadioGroup<T>`        |       `T`        |           `RadioListTile<T>`            |                                  no                                  |
|        `FastRangeSlider`         |  `RangeValues`   |              `RangeSlider`              |                                  no                                  |
|     `FastSegmentedButton<T>`     |     `Set<T>`     |          `SegmentedButton<T>`           |                                  no                                  |
|    `FastSegmentedControl<T>`     |       `T`        |                   no                    |                `CupertinoSlidingSegmentedControl<T>`                 |
|           `FastSlider`           |     `double`     |            `Slider.adaptive`            |                          `CupertinoSlider`                           |
|           `FastSwitch`           |      `bool`      |            `SwitchListTile`             |                          `CupertinoSwitch`                           |
|         `FastTextField`          |     `String`     |             `TextFormField`             |                     `CupertinoTextFormFieldRow`                      |
|         `FastTimePicker`         |   `TimeOfDay`    |            `showTimePicker`             | no <br> use `FastDatePicker` with <br>`CupertinoDatePickerMode.time` |

## Adaptive Form Fields

While some form controls are unique to a certain platform, various others are present in multiple design languages.

By default, Flutter Fast Forms uses Material widgets on any platform. 

This behavior is adjustable so that platform-specific Cupertino widgets are automatically rendered on iOS.

> [!TIP]
> The [widget catalog](#widget-catalog) tells you which `FastFormControl` is adaptive. 

<br/>

📓 **Example**: Always use Cupertino widgets on iOS in a `FastForm`.

```dart
FastForm(
  formKey: formKey,
  adaptive: true,
  children: [
    const FastSwitch(
      name: 'switch',
      titleText: 'Disable text field',
    ),
    FastTextField(
      name: 'text_field',
      labelText: 'Just some sample text field',
    ),    
  ]
),
```
> [!NOTE]
> * When `adaptive` is set to `true` any built-in `FormFieldBuilder` returns a corresponding Cupertino widget on iOS, if it exists.

<br/>

📓 **Example**: Only use the Cupertino widget on iOS for a dedicated `FastSwitch`.

```dart
FastForm(
  formKey: formKey,
  children: [
    const FastSwitch(
      name: 'switch',
      adaptive: true,
      titleText: 'Disable text field',
    ),
  ]
),
```


## Conditional Form Fields

Not all controls in a form are autonomous and act independent of each other. 

Occasionally, the state of a form field might be directly related to the state of some other form field as well.

Flutter Fast Forms allows you to define such conditions declaratively. 

<br/>

📓 **Example**: A `FastTextField` that is disabled when a `FastSwitch` is selected.

**1.** Add the `conditions` property to the conditional form field and assign an empty `Map`:

```dart
const FastSwitch(
  name: 'switch',
  titleText: 'Disable text field',
),
FastTextField(
  name: 'text_field',
  labelText: 'Just some sample text field',
  conditions: {},
),
```

**2.** Choose a suitable `FastConditionHandler` as `Map` key and assign a `FastConditionList`:
```dart
const FastSwitch(
  name: 'switch',
  titleText: 'Disable text field when selected',
),
FastTextField(
  name: 'text_field',
  labelText: 'Just some sample text field',
  conditions: {
    FastCondition.disabled: FastConditionList([]),
  },
)
```
> [!NOTE]
> A `FastConditionHandler` is a function that runs whenever a `FastConditionList` is checked and determines what happens when the condition is either met or not.

**3.** Add a `FastCondition` relating the field to another field:
```dart
const FastSwitch(
  name: 'switch',
  titleText: 'Disable text field when selected',
),
FastTextField(
  name: 'text_field',
  labelText: 'Just some sample text field',
  conditions: {
    FastCondition.disabled: FastConditionList([
      FastCondition(
        target: 'switch',
        test: (value, field) => value is bool && value,
      ),
    ]),
  },
),
```
> [!NOTE]
> `target` is the `name` of the `FastFormField` that the form field depends on.

<br/>

📓 **Example**: A `FastTextField` that is enabled when a `FastSwitch` **or** a `FastCheckbox` is selected.

```dart
const FastCheckbox(
  name: 'checkbox',
  titleText: 'Enable text field when selected',
),
const FastSwitch(
  name: 'switch',
  titleText: 'Enable text field when selected',
),
FastTextField(
  name: 'text_field',
  enabled: false,
  labelText: 'Just some sample text field',
  conditions: {
    FastCondition.enabled: FastConditionList([
      FastCondition(
        target: 'switch',
        test: (value, field) => value is bool && value,
      ),
      FastCondition(
        target: 'checkbox',
        test: (value, field) => value is bool && value,
      ),
    ]),
  },
),
```

<br/>

📓 **Example**: A `FastTextField` that is disabled when both a `FastSwitch` **and** a `FastCheckbox` are selected.

```dart
const FastCheckbox(
  name: 'checkbox',
  titleText: 'Disable text field when selected',
),
const FastSwitch(
  name: 'switch',
  titleText: 'Disable text field when selected',
),
FastTextField(
  name: 'text_field',
  labelText: 'Just some sample text field',
  conditions: {
    FastCondition.enabled: FastConditionList(
      [
        FastCondition(
          target: 'switch',
          test: (value, field) => value is bool && value,
        ),
        FastCondition(
          target: 'checkbox',
          test: (value, field) => value is bool && value,
        ),
      ],
      match: FastConditionMatch.every,
    ),
  },
),
```
> [!NOTE]
> `match` specifies how all individual test results in the list are evaluated to determine whether the condition is met.


## Custom Form Fields

There are use cases where the widget catalog does not fully satisfy your individual requirements. 

As a consequence you have to add non-standard controls to your form.

With Flutter Fast Forms you're free to wrap any custom widget into a form field.

<br/>

📓 **Example**: A simple widget that provides a random integer whenever a button is pressed.

**1.** Create a stateful widget class extending `FastFormField<T>` with a corresponding `FastFormFieldState<T>`:
```dart
class MyCustomField extends FastFormField<int> {
  const MyCustomField({
    super.builder = myCustomFormFieldBuilder,
    super.key,
    required super.name,
  });

  @override
  MyCustomFieldState createState() => MyCustomFieldState();
}

class MyCustomFieldState extends FastFormFieldState<int> {
  @override
  MyCustomField get widget => super.widget as MyCustomField;
}
```
> [!NOTE]
> * `builder` and `name` are required constructor parameters of `FastFormField`.
> * `builder` is a standard Flutter `FormFieldBuilder<T>`.

**2.** Implement the `FormFieldBuilder<T>` returning your custom widget:
```dart
Widget myCustomFormFieldBuilder(FormFieldState<int> field) {
  field as MyCustomFieldState;
  final MyCustomFieldState(:decoration, :didChange, :value) = field;

  return InputDecorator(
    decoration: decoration,
    child: Row(
      children: [
        ElevatedButton(
          child: const Text('Create random number'),
          onPressed: () => didChange(Random().nextInt(1 << 32)),
        ),
        if (value is int)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(value.toString()),
          )
      ],
    ),
  );
}
```
> [!NOTE]
> * Casting `field` is mandatory to access `FastFormField` properties and functions.
> * Always call `field.didChange()` to update the value of the form field.

**3.** Add all super-initializer parameters that the form field should support:
```dart
class MyCustomField extends FastFormField<int> {
  const MyCustomField({
    super.builder = myCustomFormFieldBuilder,
    super.decoration,
    super.enabled,
    super.helperText,
    super.initialValue,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.onTouched,
    super.validator,
  });

  @override
  MyCustomFieldState createState() => MyCustomFieldState();
}
```
> [!NOTE]
> Always make sure that you apply certain super-initializer parameters like `decoration` or `enabled` in your builder functions.
> Otherwise assigning those arguments when invoking the constructor won't have any effect.
