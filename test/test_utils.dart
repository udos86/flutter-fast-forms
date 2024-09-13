import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

typedef GenericTypeOf = Type Function<T>();

Type typeOf<T>() => T;

Finder findButtonSegments<T>() =>
    find.descendant(of: findSegmentedButton<T>(), matching: find.byType(Text));

Finder findCalendarDatePicker() => find.byType(CalendarDatePicker);

Finder findCupertinoCheckbox() => find.byType(CupertinoCheckbox);

Finder findCupertinoDatePicker() => find.byType(CupertinoDatePicker);

Finder findCupertinoFormRow() => find.byType(CupertinoFormRow);

Finder findCupertinoFormSection() => find.byType(CupertinoFormSection);

Finder findCupertinoSlider() => find.byType(CupertinoSlider);

Finder findCupertinoSwitch() => find.byType(CupertinoSwitch);

Finder findCupertinoTextField() => find.byType(CupertinoTextField);

Finder findCupertinoTextFormFieldRow() =>
    find.byType(CupertinoTextFormFieldRow);

Finder findCheckboxListTile() => find.byType(CheckboxListTile);

Finder findChoiceChip() => find.byType(ChoiceChip);

Finder findDropdown<T>() => find.byType(typeOf<DropdownButton<T>>());

Finder findDropdownButton<T>() => find.byType(typeOf<DropdownButton<T>>());

Finder findDropdownButtonFormField<T>() =>
    find.byType(typeOf<DropdownButtonFormField<T>>());

Finder findDropdownMenuItem<T>() => find.byType(typeOf<DropdownMenuItem<T>>());

Finder findExpanded() => find.byType(Expanded);

Finder findFastAutocomplete<O extends Object>() =>
    find.byType(typeOf<FastAutocomplete<O>>());

Finder findFastCalendar() => find.byType(FastCalendar);

Finder findFastCheckbox() => find.byType(FastCheckbox);

Finder findFastChipsInput() => find.byType(FastChipsInput);

Finder findFastChoiceChips<T>() => find.byType(typeOf<FastChoiceChips<T>>());

Finder findFastDatePicker() => find.byType(FastDatePicker);

Finder findFastDateRangePicker() => find.byType(FastDateRangePicker);

Finder findFastDropdown<T>() => find.byType(typeOf<FastDropdown<T>>());

Finder findFastForm() => find.byType(FastForm);

Finder findFastFormArray<T>() => find.byType(typeOf<FastFormArray<T>>());

Finder findFastFormSection() => find.byType(FastFormSection);

Finder findFastRadioGroup<T>() => find.byType(typeOf<FastRadioGroup<T>>());

Finder findFastRangeSlider() => find.byType(FastRangeSlider);

Finder findFastSegmentedButton<T>() =>
    find.byType(typeOf<FastSegmentedButton<T>>());

Finder findFastSegmentedControl<T extends Object>() =>
    find.byType(typeOf<FastSegmentedControl<T>>());

Finder findFastSlider() => find.byType(FastSlider);

Finder findFastSwitch() => find.byType(FastSwitch);

Finder findFastTextField() => find.byType(FastTextField);

Finder findFastTimePicker() => find.byType(FastTimePicker);

Finder findForm() => find.byType(Form);

Finder findIconButton() => find.byType(IconButton);

Finder findInkWell() => find.byType(InkWell);

Finder findInputChip() => find.byType(InputChip);

Finder findInputDecorator() => find.byType(InputDecorator);

Finder findListView() => find.byType(ListView);

Finder findRadioListTile<T>() => find.byType(typeOf<RadioListTile<T>>());

Finder findRangeSlider() => find.byType(RangeSlider);

Finder findRow() => find.byType(Row);

Finder findSegmentedButton<T>() => find.byType(typeOf<SegmentedButton<T>>());

Finder findSegmentedControlButton<T extends Object>() =>
    find.descendant(of: findSegmentedControl<T>(), matching: find.byType(Text));

Finder findSegmentedControl<T extends Object>() =>
    find.byType(typeOf<CupertinoSlidingSegmentedControl<T>>());

Finder findSlider() => find.byType(Slider);

Finder findSwitch() => find.byType(Switch);

Finder findSwitchListTile() => find.byType(SwitchListTile);

Finder findTextButton() => find.byType(TextButton);

Finder findTextFormField() => find.byType(TextFormField);

Finder findWrap() => find.byType(Wrap);

MaterialApp buildMaterialTestApp(List<Widget> testWidgets,
    {GlobalKey<FormState>? formKey}) {
  return MaterialApp(
    home: Scaffold(
      body: FastForm(
        formKey: formKey ?? GlobalKey<FormState>(),
        children: testWidgets,
      ),
    ),
  );
}

CupertinoApp buildCupertinoTestApp(List<Widget> testWidgets,
    {GlobalKey<FormState>? formKey}) {
  return CupertinoApp(
    home: CupertinoPageScaffold(
      child: FastForm(
        formKey: formKey ?? GlobalKey<FormState>(),
        children: testWidgets,
      ),
    ),
  );
}

class VoidCallbackSpy {
  bool _called = false;

  bool get called => _called;

  void fn() => _called = true;
}

class OnChangedSpy<T> {
  T? _arg;

  T? get calledWith => _arg;

  void fn(T? value) => _arg = value;
}
