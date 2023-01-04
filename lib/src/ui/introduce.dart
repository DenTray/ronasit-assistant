import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/resources/ronas_it_api_provider.dart';

class Introduce extends StatefulWidget {
  const Introduce({Key? key}) : super(key: key);

  @override
  State<Introduce> createState() => _IntroduceState();
}

class _IntroduceState extends State<Introduce> {
  String _firstNameInput = '';
  String _lastNameInput = '';
  String _userName = '';

  String _authError = '';

  bool _isUsernameEditMode = false;
  bool _isCompleteButtonEnable = false;

  _firstNameInputChanged(input) {
    setState(() {
      _firstNameInput = input;

      _updateUsername(null);
    });
  }

  _lastNameInputChanged(input) {
    setState(() {
      _lastNameInput = input;

      _updateUsername(null);
    });
  }

  _updateUsername(value) {
    value = value ?? generateUsername();

    _userName = value;

    _updateCompleteButtonEnable();
  }

  _updateCompleteButtonEnable() {
    _isCompleteButtonEnable = _userName.length > 3 && _authError.isEmpty;
  }

  _changeUsername() {
    setState(() {
      _isUsernameEditMode = true;
    });
  }

  _saveUsername() {
    setState(() {
      _isUsernameEditMode = false;
    });
  }

  _saveData() async {
    if (_isCompleteButtonEnable) {
      setState(() {
        _isCompleteButtonEnable = false;
      });

      RonasITApiProvider api = RonasITApiProvider.getInstance();

      try {
        await api.fetchTime(_userName);

        final preferences = await SharedPreferences.getInstance();

        await preferences.setString('user.first_name', _firstNameInput);
        await preferences.setString('user.last_name', _lastNameInput);
        await preferences.setString('user.username', _userName);

        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      } catch (error) {
        setState(() {
          _authError = '${AppLocalizations.of(context)!.messageUser} $_userName ${AppLocalizations.of(context)!.messageDoesNotExists}';
        });
      }
    }
  }

  generateUsername() {
    String firstLatter = (_firstNameInput.isNotEmpty) ? _firstNameInput.characters.first.toLowerCase() : '';

    return '$firstLatter${_lastNameInput.toLowerCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarAuthorization), centerTitle: true),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('${AppLocalizations.of(context)!.textEnterName}:')
                  ]
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    SizedBox(width: 200, child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      autocorrect: false,
                      onChanged: _firstNameInputChanged,
                      decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: AppLocalizations.of(context)!.placeholderEnterName)
                    ))
                  ]
                ),
                Row(
                  children: [
                    SizedBox(width: 200, child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      autocorrect: false,
                      onChanged: _lastNameInputChanged,
                      decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: AppLocalizations.of(context)!.placeholderEnterLastName)
                    ))
                  ]
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    Text('${AppLocalizations.of(context)!.textSetUsername}:')
                  ]
                ),
                Row(
                  children: [
                    Visibility(visible: !_isUsernameEditMode, child: Text(_userName)),
                    Visibility(visible: !_isUsernameEditMode, child: IconButton(splashRadius: 2, onPressed: _changeUsername, icon: const Icon(Icons.edit, size: 15))),
                    Visibility(visible: _isUsernameEditMode, child: SizedBox(width: 150, child: TextFormField(
                      autocorrect: false,
                      initialValue: _userName,
                      decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: AppLocalizations.of(context)!.placeholderEnterUsername),
                      onChanged: (input) {
                        setState(() {
                          _authError = '';
                          _updateUsername(input);
                          _updateCompleteButtonEnable();
                        });
                      },
                    ))),
                    Visibility(visible: _isUsernameEditMode, child: IconButton( splashRadius: 2, onPressed: _saveUsername, icon: const Icon(Icons.save, size: 15)))
                  ]
                ),
                Visibility(visible: _authError.isNotEmpty, child: Text(_authError, style: const TextStyle(fontSize: 12, color: Colors.red))),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _saveData,
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_isCompleteButtonEnable ? Colors.blue : Colors.grey)),
                      child: Text(AppLocalizations.of(context)!.buttonComplete)
                    )
                  ]
                )
              ]
            )
          ]
        )
      )
    );
  }
}
