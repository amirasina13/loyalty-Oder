import 'package:flutter/cupertino.dart';

/* Widget class for condition helper(checking password). Will use in independent/validation_pass.dart  */

/// This class helps to recognize user selected condition and check them
class OderConditionsHelper {
  OderConditionsHelper(this.strings);

  final OderPwValidatorStrings strings;
  Map<String, bool>? _selectedCondition;

  /// Recognize user selected condition from widget constructor to put them on map with their value
  void setSelectedCondition(
    int minLength,
    uppercaseCharCount,
    numericCharCount,
    lowercaseCharCount,
    specialCharCount,
  ) {
    _selectedCondition = {
      if (minLength > 0) strings.atLeast: false,
      if (uppercaseCharCount > 0) strings.uppercaseLetters: false,
      if (lowercaseCharCount > 0) strings.lowercaseLetters: false,
      if (numericCharCount > 0) strings.numericCharacters: false,
      if (specialCharCount > 0) strings.specialCharacters: false,
    };
  }

  /// Checks condition new value and passed validator, sets that in map and return new value;
  dynamic checkCondition(
    int userRequestedValue,
    Function validator,
    TextEditingController controller,
    String key,
    dynamic oldValue,
  ) {
    dynamic newValue;

    /// If the userRequested Value is grater than 0 that means user select them and we have to check new value;
    if (userRequestedValue > 0) {
      newValue = validator(controller.text, userRequestedValue);
    } else {
      newValue = null;
    }

    if (newValue == null) {
      return null;
    } else if (newValue != oldValue) {
      _selectedCondition![key] = newValue;
      return newValue;
    } else {
      return oldValue;
    }
  }

  Map<String, bool>? getter() => _selectedCondition;
}

/// Strings hold constant strings used across the package
class OderPwValidatorStrings {
  final String atLeast = " 8-16 characters";
  final String uppercaseLetters = " uppercase";
  final String numericCharacters = " numbers";
  final String lowercaseLetters = " lowercase";
  final String specialCharacters = "- Special character";
}
