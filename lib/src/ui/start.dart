import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  String _loader = '';
  String _userFullName = '';

  bool _isSplashDisplaying = true;
  bool _isWelcomeDisplaying = false;

  @override
  void initState() {
    super.initState();

    showLoader();

    showNextScreen();
  }

  showLoader() async {
    do {
      setState(() {
        if (_loader.length < 3) {
          _loader += '.';
        } else {
          _loader = '';
        }
      });

      await Future.delayed(const Duration(milliseconds: 400));
    } while (_isSplashDisplaying);
  }

  showNextScreen() async {
    final preferences = await SharedPreferences.getInstance();

    String firstName = preferences.getString('user.first_name') ?? '';
    String lastName = preferences.getString('user.last_name') ?? '';
    String userName = preferences.getString('user.username') ?? '';

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isSplashDisplaying = false;
    });

    if (userName.isNotEmpty) {
      showWelcomeScreen(firstName, lastName, userName);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/introduce', (route) => false);
    }
  }

  showWelcomeScreen(firstName, lastName, username) async {
    setState(() {
      _userFullName = (firstName.isNotEmpty) ? '$firstName $lastName' : username;
      _isWelcomeDisplaying = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(visible: _isSplashDisplaying, child: Text(AppLocalizations.of(context)!.textAuthorization)),
                Visibility(visible: _isSplashDisplaying, child: Text(_loader)),
                Visibility(visible: _isWelcomeDisplaying, child: Text('${AppLocalizations.of(context)!.textWelcome} $_userFullName'))
              ]
            )
          ]
        )
      )
    );
  }
}
