import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import 'package:keyaura/view/mobile/home.dart' as mobile;
import 'package:keyaura/view/desktop/home.dart' as desktop;

void main() {
  if (Platform.isAndroid || Platform.isIOS) {
    // Running on mobile (Android or iOS)
    runMobileApp();
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    // Running on desktop (Windows, macOS, or Linux)
    runDesktopApp();
  }
}

void runMobileApp() {
  // Mobile-specific initialization
  runApp(const GetMaterialApp(home: mobile.Home()));
}

void runDesktopApp() {
  // Desktop-specific initialization
  runApp(const GetMaterialApp(home: desktop.Home()));
}
