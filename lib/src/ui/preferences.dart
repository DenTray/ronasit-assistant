import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './shared/cupertino_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/blocs/settings/settings_bloc.dart';
import 'package:ronas_assistant/src/blocs/settings/settings_state.dart';
import 'package:ronas_assistant/src/blocs/settings/events/update_rate_event.dart';
import 'package:ronas_assistant/src/blocs/settings/events/get_settings_event.dart';
import 'package:ronas_assistant/src/blocs/settings/events/update_locale_event.dart';
import 'package:ronas_assistant/src/blocs/settings/events/update_rate_currency_event.dart';
import 'package:ronas_assistant/src/blocs/settings/events/update_working_days_count_event.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  final List <int> _daysCount = <int> [1, 2, 3, 4, 5, 6, 7];
  final List <String> _locales = <String> ['en', 'ru'];
  final List <String> _currencies = <String> ['\$', '₽'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(GetSettingsEvent()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarPreferences), centerTitle: true),
            body: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              prefferedWorkingDaysCountSetting(state.workingDaysCount, (int selectedItem) => context.read<SettingsBloc>().add(UpdateWorkingDaysCountEvent(selectedItem + 1))),
              languageSetting(state.locale, (int index) {
                context.read<SettingsBloc>().add(UpdateLocaleEvent(_locales[index]));
                _showChangeLocaleDialog();
              }),
              rateSetting(
                state.rate,
                (int index) {
                  context.read<SettingsBloc>().add(UpdateRateEvent(index.toString(), null));
                },
                (int index) {
                  context.read<SettingsBloc>().add(UpdateRateEvent(null, index.toString()));
                }
              ),
              currencySetting(state.rateCurrency, (index) {
                context.read<SettingsBloc>().add(UpdateRateCurrencyEvent(_currencies[index]));
              }),
            ])
          );
        }
      )
    );
  }

  Widget prefferedWorkingDaysCountSetting(currentValue, changeValueCallback) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 15)),
        Text(AppLocalizations.of(context)!.textPreferredDaysCount),
        const Spacer(),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(currentValue.toString(), style: const TextStyle(fontSize: 20.0)),
          onPressed: () => _showCupertinoDialog(
            CupertinoDialog(
              items: _daysCount,
              currentItem: currentValue,
              onSelectedItemChangedCallback: changeValueCallback
            )
          )
        ),
        const Padding(padding: EdgeInsets.only(left: 15))
      ]
    );
  }

  Widget currencySetting(currentValue, selectItemCallback) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 15)),
        Text(AppLocalizations.of(context)!.textCurrency),
        const Spacer(),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(currentValue, style: const TextStyle(fontSize: 20.0)),
          onPressed: () => _showCupertinoDialog(
            CupertinoDialog(
              items: _currencies,
              currentItem: currentValue,
              onSelectedItemChangedCallback: selectItemCallback
            )
          )
        ),
        const Padding(padding: EdgeInsets.only(left: 15))
      ]
    );
  }

  Widget languageSetting(currentValue, changeValueCallback) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 15)),
        Text(AppLocalizations.of(context)!.textLanguage),
        const Spacer(),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(currentValue, style: const TextStyle(fontSize: 20.0)),
          onPressed: () => _showCupertinoDialog(
            CupertinoDialog(
              items: _locales,
              currentItem: currentValue,
              onSelectedItemChangedCallback: changeValueCallback
            )
          )
        ),
        const Padding(padding: EdgeInsets.only(left: 15))
      ]
    );
  }

  Widget rateSetting(currentValue, intPartChangeCallback, decimalPartChangeCallback) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 15)),
        Text(AppLocalizations.of(context)!.textRate),
        const Spacer(),
        CupertinoButton(
          child: Text(currentValue.toString()),
          onPressed: () => _showCupertinoDialog(
            height: 500.0,
            Container(
              height: 300.0,
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: currentValue.toInt() ),
                      itemExtent: 32.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: intPartChangeCallback,
                      children: List.generate(1001, (int index) => Center(child: Text(index.toString())))
                    ),
                  ),
                  const Center(child: Text('.')),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: int.parse(currentValue.toString().split('.')[1])),
                      itemExtent: 32.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: decimalPartChangeCallback,
                      children: List.generate(100, (int index) => Center(child: Text(index.toString().padLeft(2, '0'))))
                    )
                  ),
                ],
              ),
            )
          )
        ),
        const Padding(padding: EdgeInsets.only(left: 15))
      ],
    );
  }

  void _showChangeLocaleDialog() {
    showCupertinoModalPopup <void> (
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.popupInfo),
        content: Text(AppLocalizations.of(context)!.messageRebootRequired),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(AppLocalizations.of(context)!.buttonRestart),
            onPressed: () => Phoenix.rebirth(context)
          ),
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.buttonLater),
            onPressed: () => Navigator.of(context).pop(true)
          )
        ]
      )
    );
  }

  void _showCupertinoDialog(Widget child, { height = 200.0 }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(top: false, child: child)
        );
      }
    );
  }
}