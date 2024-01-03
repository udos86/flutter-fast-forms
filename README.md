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
* `touched` [**validation state**](https://github.com/flutter/flutter/issues/18885).
* Common `FormFieldValidator<T>` functions

---

<img src="https://github.com/udos86/flutter-fast-forms/assets/508325/13708c6d-ac19-4101-bb3a-2ef6fb6a8f54" width="200" 
/><img src="https://github.com/udos86/flutter-fast-forms/assets/508325/a5537d99-4eba-46ae-a716-d4623d88b714" width="200"
/><img src="https://github.com/udos86/flutter-fast-forms/assets/508325/7855459f-d872-4524-8c29-0271e7f9630f" width="200"
/><img src="https://github.com/udos86/flutter-fast-forms/assets/508325/efe8f17f-149a-4e99-aaa5-59ce7172ccfc" width="200"/> 

<img src="https://user-images.githubusercontent.com/508325/137577735-9733ebc2-d7e3-4566-b68f-b8cfbfb373ca.png" width="200"
/><img src="https://user-images.githubusercontent.com/508325/137577821-454f9bb8-aaf2-4dc5-82e4-c7d70b04f426.png" width="200"
/><img src="https://user-images.githubusercontent.com/508325/137577765-078ab415-8de3-4ad1-aa87-947603b8279b.png" width="200"/> 


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

**2.** Add `FastFormControl<T>` children to build up your form:
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
)
```

**3.** Wrap children with `FastFormSection` for grouping and consistent padding:
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
)
```


## Widget Catalog

| adaptive<br>`FastFormControl<T>` |            wraps<br>Material            |                          wraps<br>Cupertino                          |
|:--------------------------------:|:---------------------------------------:|:--------------------------------------------------------------------:|
|        `FastAutocomplete`        |             `Autocomplete`              |                                  no                                  |
|          `FastCheckbox`          |           `CheckboxListTile`            |                         `CupertinoCheckbox`                          |
|        `FastChoiceChips`         |              `ChoiceChip`               |                                  no                                  |
|          `FastCalendar`          |          `CalendarDatePicker`           |                                  no                                  |
|         `FastDatePicker`         |            `showDatePicker`             |                        `CupertinoDatePicker`                         |
|      `FastDateRangePicker`       |          `showDateRangePicker`          |                                  no                                  |
|          `FastDropdown`          | `DropdownButtonFormField`<br>`<String>` |                                  no                                  |
|         `FastChipsInput`         |      `Autocomplete` + `InputChip`       |                                  no                                  |
|         `FastRadioGroup`         |             `RadioListTile`             |                                  no                                  |
|        `FastRangeSlider`         |              `RangeSlider`              |                                  no                                  |
|      `FastSegmentedButton`       |            `SegmentedButton`            |                                  no                                  |
|      `FastSegmentedControl`      |                   no                    |                `CupertinoSlidingSegmentedControl<T>`                 |
|           `FastSlider`           |            `Slider.adaptive`            |                          `CupertinoSlider`                           |
|           `FastSwitch`           |            `SwitchListTile`             |                          `CupertinoSwitch`                           |
|         `FastTextField`          |             `TextFormField`             |                     `CupertinoTextFormFieldRow`                      |
|         `FastTimePicker`         |            `showTimePicker`             | no / use `FastDatePicker`<br>with <br>`CupertinoDatePickerMode.time` |

## Adaptive Form Fields

## Conditional Form Fields

## Custom Form Fields

There are use cases where the widget catalog does not fully satisfy your individual requirements. 

As a consequence you have to add non-standard controls to your form.

With Flutter Fast Forms you're free to wrap any custom widget into a form field.
<hr>

📓 **Example**: A simple widget that provides a random integer whenever a button is pressed.

<hr>

1. Create a stateful widget class extending `FastFormField<T>` with a corresponding `FastFormFieldState<T>`:
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

2. Implement the `FormFieldBuilder<T>` returning your custom widget:
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

3. Add all super-initializer parameters that the form field should support:
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
    super.validator,
  });

  @override
  MyCustomFieldState createState() => MyCustomFieldState();
}
```
