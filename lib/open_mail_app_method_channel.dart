import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'open_mail_app_platform_interface.dart';

/// An implementation of [OpenMailAppPlatform] that uses method channels.
class MethodChannelOpenMailApp extends OpenMailAppPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('open_mail_app');

  @override
  Future<OpenMailAppResult> openMailApp({String nativePickerTitle = ''}) async {
    final result = await methodChannel.invokeMethod<bool>(
          'openMailApp',
          <String, dynamic>{'nativePickerTitle': nativePickerTitle},
        ) ??
        false;
    return OpenMailAppResult(didOpen: result);
  }

  @override
  Future<bool> openSpecificMailApp(MailApp mailApp) async {
    return await methodChannel.invokeMethod<bool>(
          'openSpecificMailApp',
          <String, dynamic>{'name': mailApp.name},
        ) ??
        false;
  }

  @override
  Future<List<MailApp>> getMailApps() async {
    final appsJson = await methodChannel.invokeMethod<String>('getMailApps');
    final apps = <MailApp>[];

    if (appsJson != null) {
      apps.addAll(
        (jsonDecode(appsJson) as Iterable)
            .map((x) => MailApp.fromJson(x))
            .where((app) => !['paypal'].contains(app.name.toLowerCase())),
        // TODO: Fix app filtering (perhaps use packageName instead of name)
      );
    }

    return apps;
  }
}
