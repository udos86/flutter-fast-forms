# Flutter Fast Forms

[![CI](https://github.com/udos86/flutter-fast-forms/workflows/CI/badge.svg)](https://github.com/udos86/flutter-fast-forms/actions)
[![Pub Version](https://img.shields.io/pub/v/flutter_fast_forms)](https://pub.dev/packages/flutter_fast_forms)
[![codecov](https://codecov.io/gh/udos86/flutter-fast-forms/branch/master/graph/badge.svg)](https://codecov.io/gh/udos86/flutter-fast-forms)

Flutter Fast Forms is a package for building Flutter forms fast.

It enhances the Flutter SDK with 

* a set of `FormField<T>` wrappers based on built-in `TexFormField` / `DropdownButtonFormField` implementation for all [Material input / selection components](https://flutter.dev/docs/development/ui/widgets/material#Input%20and%20selections) 
that provide platform-specific `FormFieldBuilder<T>` (when appropriate)
* a lightweight meta layer of adaptive form widgets that allows for custom validation states beyond `AutovalidateMode` 
and populating all field values on `Form` changes
* a collection of common `FormFieldValidator<T>` functions and a `TextInputFormatter` to mask text fields 
