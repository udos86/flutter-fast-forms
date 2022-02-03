# Flutter Fast Forms

[![CI](https://github.com/udos86/flutter-fast-forms/workflows/CI/badge.svg)](https://github.com/udos86/flutter-fast-forms/actions)
[![Pub Version](https://img.shields.io/pub/v/flutter_fast_forms)](https://pub.dev/packages/flutter_fast_forms)
[![codecov](https://codecov.io/gh/udos86/flutter-fast-forms/branch/master/graph/badge.svg)](https://codecov.io/gh/udos86/flutter-fast-forms)

Flutter Fast Forms is a Dart package for building Flutter forms fast.

It adds these missing pieces to the Flutter SDK to make Flutter form development a breeze: 

* `FormField<T>` wrappers for all [Material](https://flutter.dev/docs/development/ui/widgets/material#Input%20and%20selections) / [Cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) input widgets **according** to the already built-in [TextFormField](https://api.flutter.dev/flutter/material/TextFormField-class.html) / [DropdownButtonFormField](https://api.flutter.dev/flutter/material/DropdownButtonFormField-class.html) 
* **adaptive** and highly **customizable** `FastFormControl<T>` widgets with support for [**validation states**](https://github.com/flutter/flutter/issues/18885).
* `FastForm` widget that passes current form field values to `onChanged`
* `FastInputChips` widget that converts text input into chips as defined by [Material Design](https://material.io/components/chips#input-chips)  
* common `FormFieldValidator<T>` functions

---

<img src="https://user-images.githubusercontent.com/508325/147917035-5401464e-39c2-4252-bf02-4a6b4b9f35b4.png" width="200" 
/><img src="https://user-images.githubusercontent.com/508325/147917338-0135b3cb-a42c-4876-81b7-882dcada54ae.png" width="200"
/><img src="https://user-images.githubusercontent.com/508325/137577498-afa96763-c4fb-400b-9810-61f68bae4911.png" width="200"
/><img src="https://user-images.githubusercontent.com/508325/137577595-205ff9d9-669a-4e62-848d-084bfae134e1.png" width="200"/> 

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
|          `FastCheckbox`          |            `CheckboxListTile`           |                                  no                                  |                               yes                              |
|         `FastChoiceChips`        |               `ChoiceChip`              |                                  no                                  |                               yes                              |
|          `FastCalendar`          |           `CalendarDatePicker`          |                                  no                                  |                               yes                              |
|         `FastDatePicker`         |             `showDatePicker`            |                         `CupertinoDatePicker`                        |                               no                               |
|       `FastDateRangePicker`      |          `showDateRangePicker`          |                                  no                                  |                               yes                              |
|          `FastDropdown`          | `DropdownButtonFormField`<br>`<String>` |                                  no                                  |                               yes                              |
|         `FastInputChips`         |       `Autocomplete` + `InputChip`      |                                  no                                  |                               yes                              |
|         `FastRadioGroup`         |             `RadioListTile`             |                                  no                                  |                               yes                              |
|         `FastRangeSlider`        |              `RangeSlider`              |                                  no                                  |                               yes                              |
|      `FastSegmentedControl`      |                    no                   |                `SlidingSegmenteControl`<br>`<String>`                |                               no                               |
|           `FastSlider`           |            `Slider.adaptive`            |                           `CupertinoSlider`                          |                               no                               |
|           `FastSwitch`           |             `SwitchListTile`            |                           `CupertinoSwitch`                          |                               no                               |
|          `FastTextField`         |             `TextFormField`             |                      `CupertinoTextFormFieldRow`                     |                               no                               |
|         `FastTimePicker`         |             `showTimePicker`            | no / use `FastDatePicker`<br>with <br>`CupertinoDatePickerMode.time` |                               yes                              |


## Custom Form Field Widgets

With Flutter Fast Forms transforming any custom widget into a form field goes smoothly.

Let's assume a simple form field that provides a random integer whenever a button is pressed.

1. Create a minimal `FastFormField<T>` and a corresponding `FastFormFieldState<T>`:
```dart
class MyCustomField extends FastFormField<int> {
  const MyCustomField({
    Key? key,
    required String name,
  }) : super(
          builder: _myCustomFormFieldBuilder,
          key: key,
          name: name,
        );

  @override
  MyCustomFieldState createState() => MyCustomFieldState();
}

class MyCustomFieldState extends FastFormFieldState<int> {
  @override
  FastSimpleCustomField get widget => super.widget as FastSimpleCustomField;
}
```

2. Add optional parameters and pass them as you like:
```dart
class MyCustomField extends FastFormField<int> {
  const MyCustomField({
    InputDecoration? decoration,
    String? helperText,
    int? initialValue,
    Key? key,
    String? labelText,
    required String name,
    ValueChanged<int>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<int>? onSaved,
    FormFieldValidator<int>? validator,
  }) : super(
          builder: _myCustomFormFieldBuilder,
          helperText: helperText,
          initialValue: initialValue,
          key: key,
          labelText: labelText,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  @override
  MyCustomFieldState createState() => MyCustomFieldState();
}

class MyCustomFieldState extends FastFormFieldState<int> {
  @override
  FastSimpleCustomField get widget => super.widget as FastSimpleCustomField;
}
```

3. Implement the required `FormFieldBuilder<T>`:
```dart
Widget _myCustomFormFieldBuilder(FormFieldState<int> field) {
  final decoration = (field as FastSimpleCustomFieldState)
      .decoration
      .copyWith(errorText: field.errorText);

  return InputDecorator(
    decoration: decoration,
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