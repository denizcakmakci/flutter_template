import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/init/cache/locale_manager.dart';
import 'core/init/language/lang_manager.dart';
import 'core/init/navigation/navigation_routes.dart';
import 'core/init/navigation/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  LocaleManager.prefrencesInit();

  runApp(EasyLocalization(
    supportedLocales: LanguageManager.instance.supportedLocales,
    path: LanguageManager.langPath,
    child: DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => _MyApp(),
    ),
  ));
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      //theme: AppThemeLight.instance.theme,
      home: const Scaffold(),
      onGenerateRoute: NavigationRoute.instance.generateRoute,
      navigatorKey: NavigationService.instance.navigatorKey,
    );
  }
}
