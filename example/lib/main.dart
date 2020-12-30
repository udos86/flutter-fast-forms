import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import 'custom_form_field.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Flutter Fast Forms Example';

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return CupertinoApp(
          title: title,
          home: FormPage(
            title: title,
          ),
        );

      case TargetPlatform.android:
      default:
        return MaterialApp(
          title: title,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FormPage(
            title: title,
          ),
        );
    }
  }
}

class FormPage extends StatelessWidget {
  FormPage({Key key, this.title}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String title;

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(title),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FastForm(
                    adaptive: true,
                    formKey: formKey,
                    children: _buildCupertinoFormModel(context),
                    onChanged: (value) =>
                        print('Form changed: ${value.toString()}'),
                  ),
                  CupertinoButton(
                    child: Text('Reset'),
                    onPressed: () => formKey.currentState.reset(),
                  )
                ],
              ),
            ),
          ),
        );

      case TargetPlatform.android:
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FastForm(
                    formKey: formKey,
                    children: _buildFormModel(context),
                    onChanged: (value) =>
                        print('Form changed: ${value.toString()}'),
                  ),
                  RaisedButton(
                    child: Text('Reset'),
                    onPressed: () => formKey.currentState.reset(),
                  )
                ],
              ),
            ),
          ),
        );
    }
  }

  List<Widget> _buildFormModel(BuildContext context) {
    return [
      FastFormSection(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        header: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Form Example Section',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          FastDatePicker(
            id: 'date_picker',
            label: 'Date Picker',
            firstDate: DateTime(1970),
            lastDate: DateTime(2040),
          ),
          FastDateRangePicker(
            id: 'date_range_picker',
            label: 'Date Range Picker',
            firstDate: DateTime(1970),
            lastDate: DateTime(2040),
          ),
          FastTimePicker(
            id: 'time_picker',
            label: 'Time Picker',
          ),
          FastSwitch(
            id: 'switch',
            label: 'Switch',
            title: 'This is a switch',
            contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          ),
          FastTextField(
            id: 'text_field',
            label: 'Text Field',
            placeholder: 'MM/JJJJ',
            keyboardType: TextInputType.datetime,
            maxLength: 7,
            prefix: Icon(Icons.calendar_today),
            buildCounter: inputCounterWidgetBuilder,
            inputFormatters: [InputFormatters.maskText('##/####')],
            validator: Validators.compose([
              Validators.required((_value) => 'Field is required'),
              Validators.minLength(
                  7,
                  (_value, minLength) =>
                      'Field must contain at least $minLength characters'),
            ]),
          ),
          FastDropdown(
            id: 'dropdown',
            label: 'Dropdown Field',
            items: [
              'Norway',
              'Sweden',
              'Finland',
              'Denmark',
              'Iceland',
            ],
            initialValue: 'Finland',
          ),
          FastRadioGroup(
            id: 'radio_group',
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
            id: 'slider',
            label: 'Slider',
            helperText: 'A Slider with prefix and suffix widgets',
            min: 0,
            max: 10,
            prefixBuilder: (state) {
              final enabled = state.widget.enabled;
              return IconButton(
                icon: Icon(Icons.volume_off),
                onPressed:
                    enabled ? () => state.didChange(state.widget.min) : null,
              );
            },
            suffixBuilder: (state) {
              final enabled = state.widget.enabled;
              return IconButton(
                icon: Icon(Icons.volume_up),
                onPressed:
                    enabled ? () => state.didChange(state.widget.max) : null,
              );
            },
            validator: (value) => value > 8 ? 'Volume is too high' : null,
          ),
          FastRangeSlider(
            id: 'range_slider',
            label: 'Range Slider',
            min: 0,
            max: 10,
            divisions: 10,
            labelsBuilder: rangeSliderLabelsBuilder,
            prefixBuilder: rangeSliderPrefixBuilder,
            suffixBuilder: rangeSliderSuffixBuilder,
          ),
          FastCustomField(
            id: 'custom_form_field',
            label: 'Custom Form Field',
            helperText: "Optionally add some extras",
            title: Text('Extras'),
            options: [
              CustomOption(
                id: 'cheese',
                label: 'Cheese',
              ),
              CustomOption(
                id: 'bacon',
                label: 'Bacon',
              ),
            ],
          ),
          FastCalendar(
            id: 'calendar',
            label: 'Calendar',
            firstDate: DateTime(1970),
            lastDate: DateTime(2040),
          ),
          FastCheckbox(
            id: 'checkbox',
            label: 'Checkbox',
            title: 'I accept',
            contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildCupertinoFormModel(BuildContext context) {
    return [
      FastFormSection(
        adaptive: true,
        insetGrouped: true,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        header: Text('Form Example Section'),
        children: [
          FastTextField(
            id: 'text_field',
            label: 'Text Field',
            placeholder: 'Placeholder',
          ),
          FastSwitch(
            id: 'switch',
            label: 'Remind me on a day',
          ),
          FastSegmentedControl(
            id: 'segmented_control',
            label: 'Class',
            children: {
              'economy': Text('Economy'),
              'business': Text('Business'),
              'first': Text('First'),
            },
          ),
          FastSlider(
            id: 'slider',
            min: 0,
            max: 10,
            prefixBuilder: (state) {
              return CupertinoButton(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(CupertinoIcons.volume_mute),
                onPressed: state.widget.enabled
                    ? () => state.didChange(state.widget.min)
                    : null,
              );
            },
            suffixBuilder: (state) {
              return CupertinoButton(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(CupertinoIcons.volume_up),
                onPressed: state.widget.enabled
                    ? () => state.didChange(state.widget.max)
                    : null,
              );
            },
            validator: (value) => value > 8 ? 'Volume is too high' : null,
          ),
        ],
      ),
    ];
  }
}
