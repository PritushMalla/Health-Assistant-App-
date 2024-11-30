import 'package:flutter/material.dart';

String converttime(String hours, String minutes) {
  if (hours.length == 1) {
    return "0$hours:$minutes";
  } else {
    return "$hours:$minutes";
  }
}
