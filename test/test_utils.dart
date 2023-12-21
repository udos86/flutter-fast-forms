import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

typedef GenericTypeOf = Type Function<T>();

Type typeOf<T>() => T;

findButtonSegments<T>() =>
    find.descendant(of: findSegmentedButton<T>(), matching: find.byType(Text));

findCalendarDatePicker() => find.byType(CalendarDatePicker);

findCupertinoCheckbox() => find.byType(CupertinoCheckbox);

findCupertinoDatePicker() => find.byType(CupertinoDatePicker);

findCupertinoFormRow() => find.byType(CupertinoFormRow);

findCupertinoFormSection() => find.byType(CupertinoFormSection);

findCupertinoSlider() => find.byType(CupertinoSlider);

findCupertinoSwitch() => find.byType(CupertinoSwitch);

findCupertinoTextField() => find.byType(CupertinoTextField);

findCupertinoTextFormFieldRow() => find.byType(CupertinoTextFormFieldRow);

findCheckboxListTile() => find.byType(CheckboxListTile);

findChoiceChip() => find.byType(ChoiceChip);

findDropdown<T>() => find.byType(typeOf<DropdownButton<T>>());

findDropdownButton<T>() => find.byType(typeOf<DropdownButton<T>>());

findDropdownButtonFormField<T>() =>
    find.byType(typeOf<DropdownButtonFormField<T>>());

findDropdownMenuItem<T>() => find.byType(typeOf<DropdownMenuItem<T>>());

findExpanded() => find.byType(Expanded);

findFastAutocomplete<O extends Object>() =>
    find.byType(typeOf<FastAutocomplete<O>>());

findFastCalendar() => find.byType(FastCalendar);

findFastCheckbox() => find.byType(FastCheckbox);

findFastChipsInput() => find.byType(FastChipsInput);

findFastChoiceChips() => find.byType(FastChoiceChips);

findFastDatePicker() => find.byType(FastDatePicker);

findFastDateRangePicker() => find.byType(FastDateRangePicker);

findFastDropdown<T>() => find.byType(typeOf<FastDropdown<T>>());

findFastForm() => find.byType(FastForm);

findFastFormArray<T>() => find.byType(typeOf<FastFormArray<T>>());

findFastFormSection() => find.byType(FastFormSection);

findFastRadioGroup<T>() => find.byType(typeOf<FastRadioGroup<T>>());

findFastRangeSlider() => find.byType(FastRangeSlider);

findFastSegmentedButton<T>() => find.byType(typeOf<FastSegmentedButton<T>>());

findFastSegmentedControl<T>() => find.byType(typeOf<FastSegmentedControl<T>>());

findFastSlider() => find.byType(FastSlider);

findFastSwitch() => find.byType(FastSwitch);

findFastTextField() => find.byType(FastTextField);

findFastTimePicker() => find.byType(FastTimePicker);

findForm() => find.byType(Form);

findIconButton() => find.byType(IconButton);

findInkWell() => find.byType(InkWell);

findInputChip() => find.byType(InputChip);

findInputDecorator() => find.byType(InputDecorator);

findListView() => find.byType(ListView);

findRadioListTile<T>() => find.byType(typeOf<RadioListTile<T>>());

findRangeSlider() => find.byType(RangeSlider);

findRow() => find.byType(Row);

findSegmentedButton<T>() => find.byType(typeOf<SegmentedButton<T>>());

findSegmentedControlButton<T>() =>
    find.descendant(of: findSegmentedControl<T>(), matching: find.byType(Text));

findSegmentedControl<T>() =>
    find.byType(typeOf<CupertinoSlidingSegmentedControl<T>>());

findSlider() => find.byType(Slider);

findSwitch() => find.byType(Switch);

findSwitchListTile() => find.byType(SwitchListTile);

findTextButton() => find.byType(TextButton);

findTextFormField() => find.byType(TextFormField);

findWrap() => find.byType(Wrap);

MaterialApp buildMaterialTestApp(Widget testWidget,
    {GlobalKey<FormState>? formKey}) {
  return MaterialApp(
    home: Scaffold(
      body: FastForm(
        formKey: formKey ?? GlobalKey<FormState>(),
        children: [testWidget],
      ),
    ),
  );
}

CupertinoApp buildCupertinoTestApp(Widget testWidget,
    {GlobalKey<FormState>? formKey}) {
  return CupertinoApp(
    home: CupertinoPageScaffold(
      child: FastForm(
        formKey: formKey ?? GlobalKey<FormState>(),
        children: [testWidget],
      ),
    ),
  );
}

class OnChangedSpy<T> {
  T? _arg;

  T? get calledWith => _arg;

  void fn(T? value) => _arg = value;
}
