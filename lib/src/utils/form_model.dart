import '../model/form_field_group.dart';
import '../model/form_field.dart';

abstract class FormModel {
  static List<FastFormField> flatten(List<FormFieldModelGroup> formModel) {
    return formModel.fold<List<FastFormField>>([], (fields, group) {
      return [...fields, ...group.fields];
    });
  }

  static FastFormField getFieldModelById(
      fieldId, List<FormFieldModelGroup> formModel) {
    return FormModel.flatten(formModel)
        .singleWhere((model) => model.id == fieldId);
  }
}
