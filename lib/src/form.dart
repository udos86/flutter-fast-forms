import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_store.dart';
import 'form_theme.dart';

typedef FormChanged = void Function(Map<String, dynamic> value);

@immutable
class FastForm extends StatefulWidget {
  FastForm({
    @required this.children,
    this.decorationCreator,
    @required this.formKey,
    Key key,
    this.onChanged,
    this.padding,
  }) : super(key: key);

  final List<dynamic> children;
  final InputDecorationCreator decorationCreator;
  final GlobalKey<FormState> formKey;
  final FormChanged onChanged;
  final EdgeInsets padding;

  @override
  _FastFormState createState() => _FastFormState();
}

class _FastFormState extends State<FastForm> {
  FastFormStore store = FastFormStore();

  @override
  void initState() {
    super.initState();
    store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    super.dispose();
    store.removeListener(_onStoreChanged);
    store.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: store,
      child: Form(
        // onChanged: () =>, // Current store cannot be retrieved here due to the framework calling this before widget.onChanged
        key: widget.formKey,
        child: FastFormTheme(
          decorationCreator: widget.decorationCreator,
          padding: widget.padding,
          child: Column(
            children: widget.children,
          ),
        ),
      ),
    );
  }

  _onStoreChanged() {
    if (widget.onChanged != null) widget.onChanged(store.values);
  }
}
