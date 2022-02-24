import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './welcome/welcome_view.dart';
import './tree_editor/tree_editor_view.dart';
import './tree_preview/tree_preview_view.dart';
import 'themes/themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // hide annying banner!!!
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',

      // localizations:
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: AppTheme.themeMode,

      // routes:
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case TreeEditorView.routeName:
                return const TreeEditorView();
              case TreePreviewView.routeName:
                return const TreePreviewView();
              case WelcomeView.routeName:
              default:
                return const WelcomeView();
            }
          },
        );
      },
    );
  }
}
