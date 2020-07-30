import 'model/form_field_model_group.dart';
import 'model/form_field_model.dart';

abstract class FormModel {
  static List<FormFieldModel> flatten(List<FormFieldModelGroup> formModel) {
    return formModel.fold<List<FormFieldModel>>([], (fields, group) {
      return [...fields, ...group.fields];
    });
  }

  static FormFieldModel getFieldModelById(
      fieldId, List<FormFieldModelGroup> formModel) {
    return FormModel.flatten(formModel)
        .singleWhere((model) => model.id == fieldId);
  }
}
