import 'package:flutter/material.dart';
import 'package:ronas_assistant/src/ui/earn.dart';
import 'package:ronas_assistant/src/ui/stats.dart';
import 'package:ronas_assistant/src/ui/archive.dart';
import 'package:ronas_assistant/src/ui/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Base extends StatefulWidget {
  const Base({Key? key}) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Stats(),
    Earn(),
    Archive(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.appBarStats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.monetization_on_rounded),
            label: AppLocalizations.of(context)!.appBarEarned,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            label: AppLocalizations.of(context)!.appBarArchive,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.appBarProfile,
          )
        ]
      )
    );
  }
}
