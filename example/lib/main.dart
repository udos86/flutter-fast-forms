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
      title: 'Flutter Fast Forms Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FormPage(title: 'Flutter Fast Forms Demo Page'),
    );
  }
}

class FormPage extends StatefulWidget {
  FormPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: FastForm(
          formKey: formKey,
          formModel: buildFormFields(context),
        ),
      ),
    );
  }

  List<FormFieldModelGroup> buildFormFields(BuildContext context) {
    return <FormFieldModelGroup>[
      FormFieldModelGroup(
        title: Text(
          'Form Group 1',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        orientation: FormFieldModelGroupOrientation.horizontal,
        fields: [
          DateTimeModel(
            id: 97,
            label: 'Arrival',
            firstDate: DateTime(1997),
            lastDate: DateTime(2021),
          ),
          DateTimeModel(
            id: 99,
            label: 'Departure',
            firstDate: DateTime(1997),
            lastDate: DateTime(2021),
          ),
        ],
      ),
      FormFieldModelGroup(
        title: Text(
          'Form Group 2',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        fields: [
          TextFieldModel(
            id: 42,
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
          DropdownModel(
            id: 23,
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
          RadioGroupModel(
            id: 7,
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
          CustomFormFieldModel(
            id: 47,
            label: 'Custom Form Field',
            builder: (context, state) {
              final styler = FormStyle.of(context);
              return CustomFormField(
                decoration: styler.createInputDecoration(context, state.widget),
              );
            },
          ),
          CheckboxModel(
            id: 999,
            title: 'I accept',
          )
        ],
      ),
    ];
  }
}
