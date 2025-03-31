import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'open_mail_app_method_channel.dart';

abstract class OpenMailAppPlatform extends PlatformInterface {
  /// Constructs a OpenMailAppPlatform.
  OpenMailAppPlatform() : super(token: _token);

  static final Object _token = Object();

  static OpenMailAppPlatform _instance = MethodChannelOpenMailApp();

  /// The default instance of [OpenMailAppPlatform] to use.
  ///
  /// Defaults to [MethodChannelOpenMailApp].
  static OpenMailAppPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OpenMailAppPlatform] when
  /// they register themselves.
  static set instance(OpenMailAppPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Core methods that platform implementations must provide
  Future<OpenMailAppResult> openMailApp({String nativePickerTitle = ''}) {
    throw UnimplementedError('openMailApp() has not been implemented.');
  }

  Future<bool> openSpecificMailApp(MailApp mailApp) {
    throw UnimplementedError('openSpecificMailApp() has not been implemented.');
  }

  Future<List<MailApp>> getMailApps() {
    throw UnimplementedError('getMailApps() has not been implemented.');
  }
}

// Data models needed by the interface
class MailApp {
  final String name;
  final String iosLaunchScheme;

  const MailApp({
    required this.name,
    required this.iosLaunchScheme,
  });

  factory MailApp.fromJson(Map<String, dynamic> json) => MailApp(
        name: json["name"],
        iosLaunchScheme: json["iosLaunchScheme"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "iosLaunchScheme": iosLaunchScheme,
      };
}

class OpenMailAppResult {
  final bool didOpen;
  final List<MailApp> options;

  bool get canOpen => options.isNotEmpty;

  OpenMailAppResult({
    required this.didOpen,
    this.options = const <MailApp>[],
  });
}
