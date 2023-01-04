import 'package:flutter/material.dart';
import 'package:ronas_assistant/src/ui/start.dart';
import 'package:ronas_assistant/src/ui/stats.dart';
import 'package:ronas_assistant/src/ui/profile.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ronas_assistant/src/ui/introduce.dart';
import 'package:ronas_assistant/src/ui/base_view.dart';
import 'package:ronas_assistant/src/ui/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/ui/full_screen_avatar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({
    required this.preferences,
    super.key
  });

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return Phoenix(
      child: MaterialApp(
        title: 'RonasIT assistant',
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: Colors.black,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: 10, fontFamily: 'SourceSerif', fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 20, fontFamily: 'SourceSerif', fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 30, fontFamily: 'SourceSerif', fontWeight: FontWeight.bold)
          )
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', '')
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          return Locale(preferences.getString('preferences.locale') ?? 'en', '');
        },
        initialRoute: '/start',
        routes: {
          '/introduce': (context) => const Introduce(),
          '/start': (context) => const Start(),
          '/stats': (context) => const Stats(),
          '/profile': (context) => const Profile(),
          '/avatar': (context) => const Avatar(),
          '/main': (context) => const Base(),
          '/preferences': (context) => const Preferences(),
        }
      )
    );
  }
}