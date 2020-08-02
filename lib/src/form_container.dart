import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_model.dart';
import 'model/form_field_model_group.dart';
import 'model/form_field_model.dart';

class FormFieldState {
  FormFieldState({
    this.focused = false,
    this.touched = false,
    this.value,
  });

  bool focused;
  bool touched;
  dynamic value;

  void reset([value]) {
    this.focused = false;
    this.touched = false;
    this.value = value;
  }
}

typedef InputDecorationBuilder = InputDecoration Function(
    BuildContext context, FormFieldModel model);

class FormContainer extends StatefulWidget {
  FormContainer({
    decorationBuilder,
    @required this.formKey,
    @required this.formModel,
    Key key,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
  })  : this.decorationBuilder =
            decorationBuilder ?? FormBuilder.buildInputDecoration,
        super(key: key);

  final InputDecorationBuilder decorationBuilder;
  final GlobalKey<FormState> formKey;
  final List<FormFieldModelGroup> formModel;
  final EdgeInsets padding;

  @override
  State<StatefulWidget> createState() => FormContainerState();
}

class FormContainerState extends State<FormContainer> {
  final Map<int, FormFieldState> _fields = Map();
  final Map<int, TextEditingController> _controllers = Map();
  final Map<int, FocusNode> _focusNodes = Map();

  @override
  void initState() {
    super.initState();
    FormModel.flatten(widget.formModel).forEach((model) {
      _fields[model.id] = FormFieldState(
        value: model.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          key: widget.formKey,
          child: Column(
            children: [
              for (final group in widget.formModel)
                Column(
                  children: <Widget>[
                    if (group.title != null) _buildFormFieldGroupTitle(group),
                    group.orientation == FormFieldModelGroupOrientation.vertical
                        ? _buildVerticalFormFieldGroup(context, group)
                        : _buildHorizontalFormFieldGroup(context, group)
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((fieldId, controller) => controller.dispose());
    _focusNodes.forEach((fieldId, focusNode) => focusNode.dispose());
  }

  bool autovalidate(fieldId) => touched(fieldId);

  bool touched(fieldId) => _fields[fieldId].touched;

  bool focused(fieldId) => _fields[fieldId].focused;

  dynamic getFieldValue(fieldId) => _fields[fieldId].value;

  TextEditingController getController(fieldId, [String text = '']) {
    var controller = _controllers[fieldId];

    if (controller == null) {
      controller = TextEditingController(
        text: text,
      );
      controller.addListener(() => _onTextChanged(fieldId, controller));
      _controllers[fieldId] = controller;

      save(fieldId, controller.text);
    }

    return controller;
  }

  FocusNode getFocusNode(fieldId) {
    var focusNode = _focusNodes[fieldId];

    if (focusNode == null) {
      focusNode = FocusNode();
      focusNode.addListener(() => _onFocusChanged(fieldId, focusNode));
      _focusNodes[fieldId] = focusNode;
    }

    return focusNode;
  }

  void save(fieldId, value) {
    _fields[fieldId].value = value;
    print(_fields.toString());
  }

  void reset() {
    setState(() {
      widget.formKey.currentState.reset();
      _fields.forEach((fieldId, fieldState) {
        final model = FormModel.getFieldModelById(fieldId, widget.formModel);
        fieldState.reset(model.initialValue);
        if (_controllers.containsKey(fieldId)) {
          _controllers[fieldId].text = model.initialValue ?? '';
        }
      });
    });
  }

  void markAsFocused(fieldId, [bool focused = true]) {
    var fieldState = _fields[fieldId];
    if (fieldState.focused != focused) {
      setState(() => fieldState.focused = focused);
    }
  }

  void markAsTouched(fieldId, [bool touched = true]) {
    var fieldState = _fields[fieldId];
    if (fieldState.touched != touched) {
      setState(() => fieldState.touched = touched);
    }
  }

  InputDecoration buildInputDecoration(
      BuildContext context, FormFieldModel model) {
    return widget.decorationBuilder(context, model);
  }

  Widget _buildVerticalFormFieldGroup(
      BuildContext context, FormFieldModelGroup group) {
    return Column(
      children: <Widget>[
        for (final model in group.fields)
          Container(
            padding: widget.padding,
            child: model.builder(context, this, model),
          ),
      ],
    );
  }

  Widget _buildHorizontalFormFieldGroup(
      BuildContext context, FormFieldModelGroup group) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for (final model in group.fields)
          Expanded(
            child: Container(
              padding: widget.padding,
              child: model.builder(context, this, model),
            ),
          ),
      ],
    );
  }

  Widget _buildFormFieldGroupTitle(FormFieldModelGroup group) {
    return Text(
      group.title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _onTextChanged(fieldId, TextEditingController controller) {
    save(fieldId, controller.text);
  }

  void _onFocusChanged(fieldId, FocusNode focusNode) {
    if (focusNode.hasFocus) {
      markAsFocused(fieldId);
    } else {
      markAsFocused(fieldId, false);
      if (!touched(fieldId)) {
        markAsTouched(fieldId);
      }
    }
  }
}
