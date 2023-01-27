import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/blocs/profile/profile_bloc.dart';
import 'package:ronas_assistant/src/blocs/profile/profile_state.dart';
import 'package:ronas_assistant/src/blocs/profile/events/logout_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/full_avatar_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/base_profile_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/small_avatar_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/loaded_avatar_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/fetch_profile_event.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController _controller = ScrollController();
  BuildContext? blocContext = null;

  void _onScrollEvent() {
    final extentAfter = _controller.position.userScrollDirection;

    if (extentAfter == ScrollDirection.reverse) {
      blocContext?.read<ProfileBloc>().add(SmallAvatarEvent());
    }

    if (extentAfter == ScrollDirection.forward) {
      blocContext?.read<ProfileBloc>().add(FullAvatarEvent());
    }
  }

  @override
  void initState() {
    _controller.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(FetchProfileEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        blocContext = context;

        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarProfile), centerTitle: true),
          body: SingleChildScrollView(
            controller: _controller,
            clipBehavior: Clip.none,
            physics: AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              minimum: EdgeInsets.all(20),
              child: (state.isLoading)
                ? const CircularProgressIndicator()
                : Column(
                  children: [
                    userInfo(
                        state.avatarLink,
                        state.user,
                        state.isFullAvatarMode,
                        () {
                          BaseProfileEvent event = (state.isFullAvatarMode) ? SmallAvatarEvent() : FullAvatarEvent();
                          context.read<ProfileBloc>().add(event);
                        },
                        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress?.expectedTotalBytes != null && loadingProgress?.expectedTotalBytes == loadingProgress?.cumulativeBytesLoaded) {
                            context.read<ProfileBloc>().add(LoadedAvatarEvent());
                          }

                          return (state.isAvatarLoaded)
                            ? child
                            : SizedBox(
                              child: Shimmer.fromColors(
                                period: const Duration(milliseconds: 800),
                                baseColor: Color(0xFFD6D6D6),
                                highlightColor: Color(0xFFEEEEEE),
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.black)
                                )
                              ),
                            );
                        },
                        (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            context.read<ProfileBloc>().add(LoadedAvatarEvent());
                          }

                          return child;
                        }
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    emailLine(state.isFullAvatarMode, state.user!.email),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    profileButton(Icons.settings, AppLocalizations.of(context)!.buttonPreferences, () {
                      Navigator.pushNamedAndRemoveUntil(context, '/preferences', (route) => true);
                    }),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    profileButton(Icons.logout, AppLocalizations.of(context)!.buttonLogout, () {
                      context.read<ProfileBloc>().add(LogoutEvent());
                      Navigator.pushNamedAndRemoveUntil(context, '/introduce', (route) => false);
                    })
                  ]
                )
              )
            )
          );
        }
      )
    );
  }

  Widget emailLine(isFullAvatarMode, email) {
    return AnimatedContainer(
      alignment: (isFullAvatarMode) ? Alignment.center : Alignment.centerLeft,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 400),
      child: Wrap(
        children: [
          const Icon(Icons.mail, size: 25),
          const Padding(padding: EdgeInsets.only(right: 2)),
          Text(email)
        ]
      )
    );
  }

  Widget profileButton(icon, text, onPressedCallback) {
    return OutlinedButton(
      onPressed: onPressedCallback,
      style: OutlinedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 44)
      ),
      child: Row(children: [
        Icon(icon),
        const Padding(padding: EdgeInsets.only(right: 5)),
        Text(text)
      ])
    );
  }

  Widget userInfo(bigAvatarLink, user, isFullAvatarMode, onPressedCallback, loadingAvatarCallback, frameBuilder) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: onPressedCallback,
            elevation: 2.0,
            shape: const CircleBorder(),
            child: AnimatedContainer(
              width: (isFullAvatarMode) ? MediaQuery.of(context).size.width - 20 : 80.0,
              height: (isFullAvatarMode) ? MediaQuery.of(context).size.width - 20 : 80.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              child: ClipRRect(
                borderRadius: BorderRadius.circular((isFullAvatarMode) ? 0 : 40.0),
                child: Image.network(
                  bigAvatarLink,
                  loadingBuilder: loadingAvatarCallback,
                  frameBuilder: frameBuilder
                )
              )
            )
          ),
          Wrap(
            direction: Axis.vertical,
            spacing: 5,
            children: [
              Visibility(
                visible: user.fistName.isNotEmpty && user.lastName.isNotEmpty,
                child: Row(children: [
                  Text(user.fistName),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Text(user.lastName)
                ])
              ),
              Row(children: [
                const Icon(Icons.alternate_email_sharp, size: 25),
                Text(user.userName)
              ])
            ]
          )
        ]
      )
    );
  }
}