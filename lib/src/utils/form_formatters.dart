import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

abstract class InputFormatters {
  static MaskTextInputFormatter maskText(String mask,
      [Map<String, RegExp> filter]) {
    return MaskTextInputFormatter(mask: mask, filter: filter);
  }
}
