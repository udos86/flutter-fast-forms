# Flutter Fast Forms

[![CI](https://github.com/udos86/flutter-fast-forms/workflows/CI/badge.svg)](https://github.com/udos86/flutter-fast-forms/actions)
[![Pub Version](https://img.shields.io/pub/v/flutter_fast_forms)](https://pub.dev/packages/flutter_fast_forms)
[![codecov](https://codecov.io/gh/udos86/flutter-fast-forms/branch/master/graph/badge.svg)](https://codecov.io/gh/udos86/flutter-fast-forms)

Flutter Fast Forms is a Dart package for building Flutter forms fast.

It adds these missing pieces to the Flutter SDK to make form development a breeze: 

* `FormField<T>` wrappers for all [Material](https://flutter.dev/docs/development/ui/widgets/material#Input%20and%20selections) / [Cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) input widgets **according** to the already built-in [TextFormField](https://api.flutter.dev/flutter/material/TextFormField-class.html) / [DropdownButtonFormField](https://api.flutter.dev/flutter/material/DropdownButtonFormField-class.html) 
* **adaptive** and highly customizable `FastFormControl<T>` widgets with support of [**validation states**](https://github.com/flutter/flutter/issues/18885).
* `FastForm` widget that provides current form field values `onChanged`
* common `FormFieldValidator<T>` functions

![fff_1](https://user-images.githubusercontent.com/508325/137481158-89c424d9-2e7b-41ce-a86e-22646d7ecf86.png)
![fff_2](https://user-images.githubusercontent.com/508325/137481545-852c2928-d074-4af6-987a-ca01c200d309.png)
![fff_3](https://user-images.githubusercontent.com/508325/137481680-7a14bb53-da2d-49bf-9d52-f40cf77c7dda.png)
![fff_4](https://user-images.githubusercontent.com/508325/137481729-3711d859-d153-4b1a-a5e0-f2c608b2e5d5.png)
![fff_5](https://user-images.githubusercontent.com/508325/137481851-04cf0bab-7315-4f87-96e2-f2ee69b29217.png)
![fff_6](https://user-images.githubusercontent.com/508325/137481875-8d025dae-ffbf-4527-b6d0-4d38fd7793e2.png)

## Getting Started

1. Add a `FastForm` to your widget tree:
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

2. Add a set of `FastFormControl<T>` to build up your form:
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

3. Wrap it all with `FastFormSection` for grouping and consistent padding:
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
