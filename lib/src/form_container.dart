import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:provider/provider.dart';

import 'model/form_field_model_group.dart';

class FastFormStore with ChangeNotifier, DiagnosticableTreeMixin {
  final Map<int, dynamic> fields = {};

  setValue(fieldId, dynamic value) {
    fields[fieldId] = value;
    notifyListeners();
  }
}

class FastForm extends StatelessWidget {
  FastForm({
    this.decorationCreator,
    @required this.formKey,
    @required this.formModel,
    Key key,
    this.padding,
  }) : super(key: key);

  final InputDecorationCreator decorationCreator;
  final GlobalKey<FormState> formKey;
  final List<FormFieldModelGroup> formModel;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FastFormStore(),
      child: Form(
        key: formKey,
        child: FormStyle(
          decorationCreator: decorationCreator,
          padding: padding,
          child: Column(
            children: formModel,
          ),
        ),
      ),
    );
  }
}
