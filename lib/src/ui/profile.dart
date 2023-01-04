import 'package:flutter/material.dart';
import 'package:ronas_assistant/src/resources/statistic_repository.dart';
import 'package:ronas_assistant/src/support/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _email = '';
  String _userName = '';
  String _userFirstName = '';
  String _userLastName = '';

  @override
  void initState() {
    super.initState();

    loadProfileData();
  }

  loadProfileData() async {
    final preferences = await SharedPreferences.getInstance();

    setState(() {
      _userFirstName = preferences.getString('user.first_name') ?? '';
      _userLastName = preferences.getString('user.last_name') ?? '';
      _userName = preferences.getString('user.username') ?? '';

      _email = '$_userName@ronasit.com';
    });
  }

  void _logout() async {
    final preferences = await SharedPreferences.getInstance();
    final StatisticRepository statisticRepository = StatisticRepository.getInstance();

    await preferences.remove('user.first_name');
    await preferences.remove('user.last_name');
    await preferences.remove('user.username');

    statisticRepository.resetCache();

    Navigator.pushNamedAndRemoveUntil(context, '/introduce', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarProfile), centerTitle: true),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(children: [
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/avatar', (route) => true);
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    shape: const CircleBorder(),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('https://www.gravatar.com/avatar/${Helpers.generateMd5(_email)}?s=200'),
                    )
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Column(children: [
                    Visibility(visible: _userFirstName.isNotEmpty && _userLastName.isNotEmpty, child: Row(children: [
                      Text(_userFirstName),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Text(_userLastName)
                    ])),
                    Row(children: [
                      const Icon(Icons.alternate_email_sharp, size: 25),
                      Text(_userName)
                    ]),
                  ]),
                ]),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(children: [
                  const Icon(Icons.mail, size: 25),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                  Text(_email)
                ]),
                const Padding(padding: EdgeInsets.only(top: 20)),
                SizedBox(
                  width: 300,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/preferences', (route) => true);
                    },
                    child: Row(children: [
                      const Icon(Icons.settings),
                      const Padding(padding: EdgeInsets.only(right: 5)),
                      Text(AppLocalizations.of(context)!.buttonPreferences)
                    ])
                  )
                ),
                SizedBox(
                  width: 300,
                  child: OutlinedButton(
                    onPressed: _logout,
                    child: Row(children: [
                      const Icon(Icons.logout),
                      const Padding(padding: EdgeInsets.only(right: 5)),
                      Text(AppLocalizations.of(context)!.buttonLogout)
                    ])
                  )
                )
              ]
            )
          ]
        )
      )
    );
  }
}