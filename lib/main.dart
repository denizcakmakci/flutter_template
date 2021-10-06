import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/helper/utils.dart';
import 'core/init/cache/locale_manager.dart';
import 'core/init/language/lang_manager.dart';
import 'core/init/navigation/navigation_routes.dart';
import 'core/init/navigation/navigation_service.dart';
import 'core/provider/provider_list.dart';
import 'core/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await LocaleManager.prefrencesInit();
  final themeProvider = ThemeProvider();
  await themeProvider.fetchLocale();
  Utils.instance.setSystemUi(ThemeProvider.instance.isDark());

  runApp(EasyLocalization(
    supportedLocales: LanguageManager.instance.supportedLocales,
    path: LanguageManager.langPath,
    child: MultiProvider(
      providers: [...ApplicationProvider.instance!.dependItems],
      child: DevicePreview(
        enabled: false, //!kReleaseMode,
        builder: (context) => _MyApp(
          themeProvider: themeProvider,
        ),
      ),
    ),
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class _MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const _MyApp({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeModel, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeProvider.theme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
      ),
    );
  }
}
