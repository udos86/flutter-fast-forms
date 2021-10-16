# Flutter Fast Forms

[![CI](https://github.com/udos86/flutter-fast-forms/workflows/CI/badge.svg)](https://github.com/udos86/flutter-fast-forms/actions)
[![Pub Version](https://img.shields.io/pub/v/flutter_fast_forms)](https://pub.dev/packages/flutter_fast_forms)
[![codecov](https://codecov.io/gh/udos86/flutter-fast-forms/branch/master/graph/badge.svg)](https://codecov.io/gh/udos86/flutter-fast-forms)

Flutter Fast Forms is a Dart package for building Flutter forms fast.

It adds these missing pieces to the Flutter SDK to make Flutter form development a breeze: 

* `FormField<T>` wrappers for all [Material](https://flutter.dev/docs/development/ui/widgets/material#Input%20and%20selections) / [Cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) input widgets **according** to the already built-in [TextFormField](https://api.flutter.dev/flutter/material/TextFormField-class.html) / [DropdownButtonFormField](https://api.flutter.dev/flutter/material/DropdownButtonFormField-class.html) 
* **adaptive** and highly **customizable** `FastFormControl<T>` widgets with support of [**validation states**](https://github.com/flutter/flutter/issues/18885).
* `FastForm` widget that provides current form field values `onChanged`
* common `FormFieldValidator<T>` functions

---

<img src="https://user-images.githubusercontent.com/508325/137577174-4a7aff02-9779-49da-9deb-3283265a258d.png" width="200" 
/><img src="https://user-images.githubusercontent.com/508325/137577498-afa96763-c4fb-400b-9810-61f68bae4911.png" width="200"
/><img src="https://user-images.githubusercontent.com/508325/137577595-205ff9d9-669a-4e62-848d-084bfae134e1.png" width="200"
/><img src="https://user-images.githubusercontent.com/508325/137577367-3921a9b2-0bfe-417d-aeef-462d375a5bcb.png" width="200"/> 

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
      id: 'field_destination',
      label: 'Destination',
      placeholder: 'Where are you going?',
    ),
    FastDateRangePicker(
      id: 'field_check_in_out',
      label: 'Check-in - Check-out',
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ),
    FastCheckbox(
      id: 'field_travel_purpose',
      label: 'Travel purpose',
      title: 'I am travelling for work',
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
          id: 'field_destination',
          label: 'Destination',
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
|         `FastRadioGroup`         |             `RadioListTile`             |                                  no                                  |                               yes                              |
|         `FastRangeSlider`        |              `RangeSlider`              |                                  no                                  |                               yes                              |
|      `FastSegmentedControl`      |                    no                   |                `SlidingSegmenteControl`<br>`<String>`                |                               no                               |
|           `FastSlider`           |            `Slider.adaptive`            |                           `CupertinoSlider`                          |                               no                               |
|           `FastSwitch`           |             `SwitchListTile`            |                           `CupertinoSwitch`                          |                               no                               |
|          `FastTextField`         |             `TextFormField`             |                      `CupertinoTextFormFieldRow`                     |                               no                               |
|         `FastTimePicker`         |             `showTimePicker`            | no / use `FastDatePicker`<br>with <br>`CupertinoDatePickerMode.time` |                               yes                              |
