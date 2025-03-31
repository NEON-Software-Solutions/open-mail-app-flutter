import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'open_mail_app_platform_interface.dart';

/// Launch Schemes for supported apps
const String kLaunchSchemeAppleMail = 'message://';
const String kLaunchSchemeGmail = 'googlegmail://';
const String kLaunchSchemeDispatch = 'x-dispatch://';
const String kLaunchSchemeSpark = 'readdle-spark://';
const String kLaunchSchemeAirmail = 'airmail://';
const String kLaunchSchemeOutlook = 'ms-outlook://';
const String kLaunchSchemeYahoo = 'ymail://';
const String kLaunchSchemeFastmail = 'fastmail://';
const String kLaunchSchemeSuperhuman = 'superhuman://';
const String kLaunchSchemeProtonmail = 'protonmail://';

class OpenMailApp {
  static final List<MailApp> _supportedMailApps = [
    MailApp(name: 'Apple Mail', iosLaunchScheme: kLaunchSchemeAppleMail),
    MailApp(name: 'Gmail', iosLaunchScheme: kLaunchSchemeGmail),
    MailApp(name: 'Dispatch', iosLaunchScheme: kLaunchSchemeDispatch),
    MailApp(name: 'Spark', iosLaunchScheme: kLaunchSchemeSpark),
    MailApp(name: 'Airmail', iosLaunchScheme: kLaunchSchemeAirmail),
    MailApp(name: 'Outlook', iosLaunchScheme: kLaunchSchemeOutlook),
    MailApp(name: 'Yahoo', iosLaunchScheme: kLaunchSchemeYahoo),
    MailApp(name: 'Fastmail', iosLaunchScheme: kLaunchSchemeFastmail),
    MailApp(name: 'Superhuman', iosLaunchScheme: kLaunchSchemeSuperhuman),
    MailApp(name: 'ProtonMail', iosLaunchScheme: kLaunchSchemeProtonmail),
  ];

  /// Opens an email app or shows picker if multiple are available.
  static Future<OpenMailAppResult> openMailApp({
    String nativePickerTitle = '',
  }) async {
    if (!_isIOS) {
      return OpenMailAppPlatform.instance.openMailApp(
        nativePickerTitle: nativePickerTitle,
      );
    }

    final apps = await _getIosMailApps();
    if (apps.length == 1) {
      final didOpen = await openSpecificMailApp(apps.first);
      return OpenMailAppResult(didOpen: didOpen);
    }
    return OpenMailAppResult(didOpen: false, options: apps);
  }

  /// Opens a specific mail app.
  static Future<bool> openSpecificMailApp(MailApp mailApp) async {
    if (!_isIOS) {
      return OpenMailAppPlatform.instance.openSpecificMailApp(mailApp);
    }
    return await launchUrl(
      Uri.parse(mailApp.iosLaunchScheme),
      mode: LaunchMode.externalApplication,
    );
  }

  /// Gets list of installed mail apps.
  static Future<List<MailApp>> getMailApps() async {
    if (!_isIOS) {
      return OpenMailAppPlatform.instance.getMailApps();
    }
    return _getIosMailApps();
  }

  static Future<List<MailApp>> _getIosMailApps() async {
    final installedApps = <MailApp>[];
    for (final app in _supportedMailApps) {
      if (await canLaunchUrl(Uri.parse(app.iosLaunchScheme))) {
        installedApps.add(app);
      }
    }
    return installedApps;
  }

  static bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
}

/// Dialog for picking an email app.
class MailAppPickerDialog extends StatelessWidget {
  final String title;
  final List<MailApp> mailApps;

  const MailAppPickerDialog({
    super.key,
    this.title = 'Choose Mail App',
    required this.mailApps,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        for (final app in mailApps)
          SimpleDialogOption(
            child: Text(app.name),
            onPressed: () {
              OpenMailApp.openSpecificMailApp(app);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
