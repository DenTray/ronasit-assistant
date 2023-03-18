import '../support/ui_helpers.dart';
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
              prefferedWorkingDaysCountSetting(context, state.workingDaysCount, context.read<SettingsBloc>()),
              const Divider(height: 0),
              languageSetting(context, state.locale, context.read<SettingsBloc>()),
              const Divider(height: 0),
              rateSetting(state.rate, context.read<SettingsBloc>()),
              const Divider(height: 0),
              currencySetting(context, context.read<SettingsBloc>(), state.rateCurrency),
            ])
          );
        }
      )
    );
  }

  Widget prefferedWorkingDaysCountSetting(context, currentValue, bloc) {
    return preferenceItem(
      () => UIHelpers.displayCupertinoDialog(context, CupertinoDialog(
        items: _daysCount,
        currentItem: currentValue,
        onSelectedItemChangedCallback: (int selectedItem) => bloc.add(UpdateWorkingDaysCountEvent(selectedItem + 1))
      )),
      Icons.calendar_month_outlined,
      AppLocalizations.of(context)!.textPreferredDaysCount
    );
  }

  Widget currencySetting(context, bloc, currentValue) {
    return preferenceItem(
      () => UIHelpers.displayCupertinoDialog(
        context,
        CupertinoDialog(
          items: _currencies,
          currentItem: currentValue,
          onSelectedItemChangedCallback: (index) => bloc.add(UpdateRateCurrencyEvent(_currencies[index]))
        )
      ),
      Icons.currency_exchange,
      AppLocalizations.of(context)!.textCurrency
    );
  }

  Widget languageSetting(context, currentValue, bloc) {
    return preferenceItem(
      () => UIHelpers.displayCupertinoDialog(
        context,
        CupertinoDialog(
          items: _locales,
          currentItem: currentValue,
          onSelectedItemChangedCallback: (int index) {
            bloc.add(UpdateLocaleEvent(_locales[index]));
            _showChangeLocaleDialog();
          }
        )
      ),
      Icons.language,
      AppLocalizations.of(context)!.textLanguage
    );
  }

  Widget rateSetting(currentValue, bloc) {
    return preferenceItem(
      () => UIHelpers.displayCupertinoDialog(
        context,
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
                  scrollController: FixedExtentScrollController(initialItem: currentValue.toInt()),
                  itemExtent: 32.0,
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (int index) => bloc.add(UpdateRateEvent(index.toString(), null)),
                  children: List.generate(1001, (int index) => Center(child: Text(index.toString())))
                ),
              ),
              const Center(child: Text('.')),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: int.parse(currentValue.toString().split('.')[1])),
                  itemExtent: 32.0,
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (int index) => bloc.add(UpdateRateEvent(null, index.toString())),
                  children: List.generate(100, (int index) => Center(child: Text(index.toString().padLeft(2, '0'))))
                )
              ),
            ],
          ),
        )
      ),
      Icons.query_stats_outlined,
      AppLocalizations.of(context)!.textRate
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

  Widget preferenceItem(onPressCallback, IconData icon, String label) {
    return OutlinedButton(
      onPressed: onPressCallback,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(style: BorderStyle.none),
        fixedSize: Size(MediaQuery.of(context).size.width, 44)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Text(label),
          ]),
          const Icon(Icons.arrow_right)
        ]
      )
    );
  }
}