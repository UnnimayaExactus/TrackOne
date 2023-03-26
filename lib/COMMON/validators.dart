import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Validate {
  static String? emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  static String? pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password should contain atleast 8 Characters';
    } else {
      return null;
    }
  }

  static String? nameValidator(String value) {
    if (value.length < 3) {
      return 'Provide Your Full Name';
    } else {
      return null;
    }
  }

  static String? numberValidator(String value) {
    if (value.length < 10 || num.tryParse(value) == null) {
      return 'Phone number should contain atleast 10 digits';
    } else {
      return null;
    }
  }
}
