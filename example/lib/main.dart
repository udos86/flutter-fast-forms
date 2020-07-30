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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: FormContainer(
          formKey: GlobalKey<FormState>(),
          formModel: [
            FormFieldGroup(
              title: 'Form Group 1',
              fields: [
                TextFormFieldModel(
                  id: 42,
                  label: 'TextField',
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
                DropdownFormFieldModel(
                  id: 23,
                  label: 'Dropdown',
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
                FormFieldModel<dynamic>(
                  id: 47,
                  label: 'Custom Form Field',
                  builder: (context, form, model) {
                    return CustomFormField(
                      decoration:
                          FormBuilder.buildInputDecoration(context, model),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
