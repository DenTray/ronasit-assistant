import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/blocs/introduce/introduce_bloc.dart';
import 'package:ronas_assistant/src/blocs/introduce/introduce_state.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/login_event.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/update_username_event.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/update_last_name_event.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/update_first_name_event.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/edit_username_mode_update_event.dart';

class Introduce extends StatefulWidget {
  const Introduce({Key? key}) : super(key: key);

  @override
  State<Introduce> createState() => _IntroduceState();
}

class _IntroduceState extends State<Introduce> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IntroduceBloc(),
      child: BlocBuilder<IntroduceBloc, IntroduceState>(builder: (context, state) {
        return  Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarAuthorization), centerTitle: true),
          body: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Row(children: [
                      Text('${AppLocalizations.of(context)!.textEnterName}:')
                    ]),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    input(AppLocalizations.of(context)!.placeholderEnterName, (input) {
                      context.read<IntroduceBloc>().add(UpdateFirstNameEvent(input));
                    }),
                    input(AppLocalizations.of(context)!.placeholderEnterLastName, (input) {
                      context.read<IntroduceBloc>().add(UpdateLastNameEvent(input));
                    }),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Row(
                      children: [
                        Text('${AppLocalizations.of(context)!.textSetUsername}:')
                      ]
                    ),
                    Row(
                      children: [
                        Visibility(visible: !state.isEditUserNameModeEnabled, child: Text(state.userName)),
                        Visibility(visible: !state.isEditUserNameModeEnabled, child: IconButton(splashRadius: 2, icon: const Icon(Icons.edit, size: 15), onPressed: () {
                          context.read<IntroduceBloc>().add(EditUsernameModeUpdate(true));
                        })),
                        Visibility(visible: state.isEditUserNameModeEnabled, child: SizedBox(width: 150, child: TextFormField(
                          autocorrect: false,
                          initialValue: state.userName,
                          decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: AppLocalizations.of(context)!.placeholderEnterUsername),
                          onChanged: (input) {
                            context.read<IntroduceBloc>().add(UpdateUsernameEvent(input));
                          },
                        ))),
                        Visibility(visible: state.isEditUserNameModeEnabled, child: IconButton( splashRadius: 2, icon: const Icon(Icons.save, size: 15), onPressed: () {
                          context.read<IntroduceBloc>().add(EditUsernameModeUpdate(false));
                        }))
                      ]
                    ),
                    Visibility(visible: state.authError == 'not_exists', child: Text('${AppLocalizations.of(context)!.messageUser} ${state.userName} ${AppLocalizations.of(context)!.messageDoesNotExists}', style: const TextStyle(fontSize: 12, color: Colors.red))),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    loginButton(state.isLoginButtonEnabled, () {
                      if (state.isLoginButtonEnabled) {
                        context.read<IntroduceBloc>().add(LoginEvent(context));
                      }
                    })
                  ]
                )
              ]
            )
          )
        );
      })
    );
  }

  Widget loginButton(isLoginButtonEnabled, onPressedCallback) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onPressedCallback,
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(isLoginButtonEnabled ? Colors.blue : Colors.grey)),
          child: Text(AppLocalizations.of(context)!.buttonComplete)
        )
      ]
    );
  }

  Widget input(String label, onChangeCallback) {
    return Row(
      children: [
        SizedBox(width: 200, child: TextFormField(
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          onChanged: onChangeCallback,
          decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: label)
        ))
      ]
    );
  }
}
