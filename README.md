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
![fff_1](https://user-images.githubusercontent.com/508325/137506640-4cfbd53f-ac18-465d-96e9-84426f8e88bf.png)
![fff_2](https://user-images.githubusercontent.com/508325/137506706-ba54ae05-580c-45c6-8b29-265cc3d3c418.png)
![fff_3](https://user-images.githubusercontent.com/508325/137506833-5399a721-b269-4069-9ce7-89f70c3001ed.png)
![fff_4](https://user-images.githubusercontent.com/508325/137506915-e646600d-6bc5-44b7-ac39-6da1366641b8.png)
![fff_7](https://user-images.githubusercontent.com/508325/137507175-9bb211b5-5fa2-483b-8a2c-5fa4f92113d9.png)
![fff_8](https://user-images.githubusercontent.com/508325/137507232-b8014080-980b-400e-b316-2123f530f9be.png)
![fff_5](https://user-images.githubusercontent.com/508325/137507001-63791436-9553-4dc4-b25b-f92d7f0b9e8d.png)
![fff_6](https://user-images.githubusercontent.com/508325/137507072-6084bb0b-b311-4b09-aea3-95ddd4f63db5.png)


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
