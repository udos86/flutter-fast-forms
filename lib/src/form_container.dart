import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:provider/provider.dart';

import 'form_store.dart';
import 'form_field_group.dart';

class FastForm extends StatelessWidget {
  FastForm({
    this.decorationCreator,
    @required this.formKey,
    @required this.model,
    Key key,
    this.padding,
  }) : super(key: key);

  final InputDecorationCreator decorationCreator;
  final GlobalKey<FormState> formKey;
  final List<FastFormFieldGroup> model;
  final EdgeInsets padding;
  final FastFormStore _store = FastFormStore();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _store,
      child: Form(
        onChanged: () => print(_store.fields.toString()),
        key: formKey,
        child: FormStyle(
          decorationCreator: decorationCreator,
          padding: padding,
          child: Column(
            children: model,
          ),
        ),
      ),
    );
  }
}
