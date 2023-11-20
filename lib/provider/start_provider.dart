import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class StartProvider extends ChangeNotifier {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  String _androidInfo = '';

  String get androidInfo => _androidInfo;

  Future<void> getDeviceInfo() async {

    notifyListeners();
  }
}
