import 'package:flutter/material.dart';

import 'model/form_field_model_group.dart';

class FormContainer extends StatefulWidget {
  FormContainer({
    @required this.formKey,
    @required this.formModel,
    Key key,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final List<FormFieldModelGroup> formModel;

  @override
  State<StatefulWidget> createState() => FormContainerState();
}

class FormContainerState extends State<FormContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          key: widget.formKey,
          child: Column(
            children: widget.formModel,
          ),
        ),
      ],
    );
  }
}
