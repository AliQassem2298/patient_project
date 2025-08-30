// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/screens/centerBage.dart';

class AuthMiddleare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (sharedPreferences!.getString("token") != null) {
      return RouteSettings(name: centerBage.id);
    }
  }
}
