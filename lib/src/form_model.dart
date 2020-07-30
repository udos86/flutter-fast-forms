import 'model/form_field_group_model.dart';
import 'model/form_field_model.dart';

abstract class FormModel {
  static List<FormFieldModel> flatten(List<FormFieldGroup> formModel) {
    return formModel.fold<List<FormFieldModel>>([], (fields, group) {
      return [...fields, ...group.fields];
    });
  }

  static FormFieldModel getFieldModelById(
      fieldId, List<FormFieldGroup> formModel) {
    return FormModel.flatten(formModel)
        .singleWhere((model) => model.id == fieldId);
  }
}
