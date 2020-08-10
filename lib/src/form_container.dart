import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_store.dart';
import 'form_field_group.dart';
import 'form_style.dart';

typedef FormChanged = void Function(Map<String, dynamic> value);

class FastForm extends StatefulWidget {
  FastForm({
    this.decorationCreator,
    @required this.formKey,
    this.initialState,
    @required this.model,
    Key key,
    this.onChanged,
    this.padding,
  }) : super(key: key);

  final InputDecorationCreator decorationCreator;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> initialState;
  final List<FastFormFieldGroup> model;
  final FormChanged onChanged;
  final EdgeInsets padding;

  @override
  _FastFormState createState() => _FastFormState();
}

class _FastFormState extends State<FastForm> {
  FastFormStore store;

  @override
  void initState() {
    super.initState();
    final _initialState = FastFormStore.fromModel(widget.model)
      ..addAll(FastFormStore.fromValues(widget.initialState, true));
    store = FastFormStore(initialState: _initialState);
    store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    super.dispose();
    store.removeListener(_onStoreChanged);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: store,
      child: Form(
        // onChanged: () =>, // Current store cannot be retrieved here due to the framework calling this before widget.onChanged
        key: widget.formKey,
        child: FormStyle(
          decorationCreator: widget.decorationCreator,
          padding: widget.padding,
          child: Column(
            children: widget.model,
          ),
        ),
      ),
    );
  }

  _onStoreChanged() {
    if (widget.onChanged != null) widget.onChanged(store.values);
  }
}
