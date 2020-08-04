import '../form_field_group.dart';
import '../form_field.dart';

abstract class FormModel {
  static List<FastFormField> flatten(List<FastFormFieldGroup> formModel) {
    return formModel.fold<List<FastFormField>>([], (fields, group) {
      return [...fields, ...group.children];
    });
  }

  static FastFormField getFieldModelById(
      fieldId, List<FastFormFieldGroup> formModel) {
    return FormModel.flatten(formModel)
        .singleWhere((model) => model.id == fieldId);
  }
}
