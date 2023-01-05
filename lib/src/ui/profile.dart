import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/blocs/profile/profile_bloc.dart';
import 'package:ronas_assistant/src/blocs/profile/profile_state.dart';
import 'package:ronas_assistant/src/blocs/profile/events/logout_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/fetch_profile_event.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(FetchProfileEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarProfile), centerTitle: true),
          body: SafeArea(
            child: (state.isLoading)
              ? const CircularProgressIndicator()
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      userInfo(state.smallAvatarLink, state.user),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      emailLine(state.user!.email),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      profileButton(Icons.settings, AppLocalizations.of(context)!.buttonPreferences, () {
                        Navigator.pushNamedAndRemoveUntil(context, '/preferences', (route) => true);
                      }),
                      profileButton(Icons.logout, AppLocalizations.of(context)!.buttonLogout, () {
                        context.read<ProfileBloc>().add(LogoutEvent());
                        Navigator.pushNamedAndRemoveUntil(context, '/introduce', (route) => false);
                      })
                    ]
                  )
                ]
              )
          )
        );
      }
    ));
  }

  Widget profileButton(icon, text, onPressedCallback) {
    return SizedBox(
      width: 300,
      child: OutlinedButton(
        onPressed: onPressedCallback,
        child: Row(children: [
          Icon(icon),
          const Padding(padding: EdgeInsets.only(right: 5)),
          Text(text)
        ])
      )
    );
  }

  Widget userInfo(smallAvatarLink, user) {
    return Row(children: [
      RawMaterialButton(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/avatar', (route) => true),
        elevation: 2.0,
        fillColor: Colors.white,
        shape: const CircleBorder(),
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(smallAvatarLink),
        )
      ),
      const Padding(padding: EdgeInsets.only(left: 10)),
      Column(children: [
        Visibility(visible: user.fistName.isNotEmpty && user.lastName.isNotEmpty, child: Row(children: [
          Text(user.fistName),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Text(user.lastName)
        ])),
        Row(children: [
          const Icon(Icons.alternate_email_sharp, size: 25),
          Text(user.userName)
        ])
      ])
    ]);
  }

  Widget emailLine(email) {
    return Row(children: [
      const Icon(Icons.mail, size: 25),
      const Padding(padding: EdgeInsets.only(right: 10)),
      Text(email)
    ]);
  }
}