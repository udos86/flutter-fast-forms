import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import 'custom_form_field.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fast Forms Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FormPage(
        title: 'Flutter Fast Forms Example',
      ),
    );
  }
}

class FormPage extends StatelessWidget {
  FormPage({Key key, this.title}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: FastForm(
          formKey: formKey,
          model: buildFormModel(context),
          onChanged: (value) => print('Form changed: ${value.toString()}'),
        ),
      ),
    );
  }

  List<FastFormFieldGroup> buildFormModel(BuildContext context) {
    return <FastFormFieldGroup>[
      FastFormFieldGroup(
        title: Text(
          'Form Group 1',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          FastDatePicker(
            id: 'date_picker_1',
            label: 'Date Picker',
            firstDate: DateTime(1997),
            lastDate: DateTime(2021),
          ),
          FastDateRangePicker(
            id: 'date_range_picker_1',
            label: 'Date Range Picker',
            firstDate: DateTime(1997),
            lastDate: DateTime(2021),
          ),
          FastTimePicker(
            id: 'time_picker_1',
            label: 'Time Picker',
          ),
          FastTextField(
            id: 'text_field_1',
            label: 'Text Field',
            hint: 'MM/JJJJ',
            validator: Validators.compose([
              Validators.required(),
              Validators.minLength(6),
            ]),
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              InputFormatters.maskText('##/####'),
            ],
          ),
          FastDropdown(
            id: 'dropdown_1',
            label: 'Dropdown Field',
            items: [
              'Norway',
              'Sweden',
              'Finland',
              'Denmark',
              'Iceland',
            ],
            initialValue: 'Finland',
            validator: Validators.required(),
          ),
          FastRadioGroup(
            id: 'radio_group_1',
            label: 'Radio Group Model',
            options: [
              RadioOption(
                title: 'Option 1',
                value: 'option-1',
              ),
              RadioOption(
                title: 'Option 2',
                value: 'option-2',
              ),
              RadioOption(
                title: 'Option 3',
                value: 'option-3',
              )
            ],
          ),
          FastSlider(
            id: 'slider_1',
            label: 'Sample Slider',
            helper: 'A Slider with prefix and suffix widgets',
            min: 0,
            max: 10,
            prefixBuilder: (context, state) => IconButton(
              icon: Icon(Icons.volume_off),
              onPressed: () => state.didChange(state.widget.min),
            ),
            suffixBuilder: (context, state) => IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () => state.didChange(state.widget.max),
            ),
            validator: (value) => value > 8 ? 'Volume is too high' : null,
          ),
          FastRangeSlider(
            id: 'range_slider_1',
            label: 'Range Slider',
            min: 0,
            max: 10,
            divisions: 10,
            labelsBuilder: rangeSliderLabelsBuilder,
            prefixBuilder: rangeSliderPrefixBuilder,
            suffixBuilder: rangeSliderSuffixBuilder,
          ),
          CustomFormFieldModel(
            id: 'custom_form_field',
            label: 'Custom Form Field',
            builder: (context, state) {
              final style = FormStyle.of(context);
              return CustomFormField(
                decoration: style.getInputDecoration(context, state.widget),
              );
            },
          ),
          FastCheckbox(
            id: 'checkbox_1',
            title: 'I accept',
          ),
        ],
      ),
    ];
  }
}
