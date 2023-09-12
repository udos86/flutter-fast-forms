# Flutter Fast Forms

[![CI](https://github.com/udos86/flutter-fast-forms/workflows/CI/badge.svg)](https://github.com/udos86/flutter-fast-forms/actions)
[![Pub Version](https://img.shields.io/pub/v/flutter_fast_forms)](https://pub.dev/packages/flutter_fast_forms)
[![codecov](https://codecov.io/gh/udos86/flutter-fast-forms/branch/master/graph/badge.svg)](https://codecov.io/gh/udos86/flutter-fast-forms)

Flutter Fast Forms is the only Dart package you'll ever need to build Flutter forms fast.

It adds these essential features to the Flutter SDK: 

* `FormField<T>` wrappers for all [Material](https://flutter.dev/docs/development/ui/widgets/material#Input%20and%20selections) / [Cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) input widgets **according** to the already built-in [TextFormField](https://api.flutter.dev/flutter/material/TextFormField-class.html) / [DropdownButtonFormField](https://api.flutter.dev/flutter/material/DropdownButtonFormField-class.html) 
* **adaptive** and highly **customizable** `FastFormControl<T>` widgets with support for [**validation states**](https://github.com/flutter/flutter/issues/18885).
* `FastForm` widget that passes current form field values to `onChanged`
* `FastFormArray` widget that aggregates a flexible list of homogeneous controls similar to `ListView.builder`
* `FastChipsInput` widget that converts text input into chips as defined by [Material Design](https://material.io/components/chips#input-chips)  
* common `FormFieldValidator<T>` functions

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
child: FastForm(
  formKey: formKey,
  children: [
    FastTextField(
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
    FastCheckbox(
      name: 'field_travel_purpose',
      labelText: 'Travel purpose',
      titleText: 'I am travelling for work',
    ),
  ],
)
```

**3.** Wrap children with `FastFormSection` for grouping and consistent padding:
```dart
child: FastForm(
  formKey: formKey,
  children: [
    FastFormSection(
      header: const Text('My Form'),
      padding: EdgeInsets.all(16.0),
      children: [
        FastTextField(
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

| adaptive<br>`FastFormControl<T>` |            adopts<br>Material           |                         adopts <br>Cupertino                         | requires <br>Material Widget ancestor<br>when `adaptive: true` |
|:--------------------------------:|:---------------------------------------:|:--------------------------------------------------------------------:|:--------------------------------------------------------------:|
|        `FastAutocomplete`        |              `Autocomplete`             |                                  no                                  |                               yes                              |
|          `FastCheckbox`          |            `CheckboxListTile`           |                         `CupertinoCheckbox`                          |                               yes                              |
|         `FastChoiceChips`        |               `ChoiceChip`              |                                  no                                  |                               yes                              |
|          `FastCalendar`          |           `CalendarDatePicker`          |                                  no                                  |                               yes                              |
|         `FastDatePicker`         |             `showDatePicker`            |                        `CupertinoDatePicker`                         |                               no                               |
|       `FastDateRangePicker`      |          `showDateRangePicker`          |                                  no                                  |                               yes                              |
|          `FastDropdown`          | `DropdownButtonFormField`<br>`<String>` |                                  no                                  |                               yes                              |
|         `FastInputChips`         |       `Autocomplete` + `InputChip`      |                                  no                                  |                               yes                              |
|         `FastRadioGroup`         |             `RadioListTile`             |                                  no                                  |                               yes                              |
|         `FastRangeSlider`        |              `RangeSlider`              |                                  no                                  |                               yes                              |
|      `FastSegmentedControl`      |                    no                   |                `SlidingSegmenteControl`<br>`<String>`                |                               no                               |
|           `FastSlider`           |            `Slider.adaptive`            |                          `CupertinoSlider`                           |                               no                               |
|           `FastSwitch`           |             `SwitchListTile`            |                          `CupertinoSwitch`                           |                               no                               |
|          `FastTextField`         |             `TextFormField`             |                     `CupertinoTextFormFieldRow`                      |                               no                               |
|         `FastTimePicker`         |             `showTimePicker`            | no / use `FastDatePicker`<br>with <br>`CupertinoDatePickerMode.time` |                               yes                              |


## Custom Form Field Widgets

Transforming any custom widget into a form field is easy to do with Flutter Fast Forms.

Let's assume a simple sample widget that provides a random integer whenever a button is pressed.

1. Create a stateful widget extending `FastFormField<T>` with a corresponding `FastFormFieldState<T>`:
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

2. Implement a `FormFieldBuilder<T>` returning your custom widget and calling `field.didChange()`:
```dart
Widget myCustomFormFieldBuilder(FormFieldState<int> field) {
  return InputDecorator(
    decoration: field.decoration,
    child: Row(
      children: [
        ElevatedButton(
          child: const Text('Create random number'),
          onPressed: () => field.didChange(Random().nextInt(1 << 32)),
        ),
        if (field.value is int)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(field.value!.toString()),
          )
      ],
    ),
  );
}
```

3. Add optional super-initializer parameters to your constructor as you like:
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
