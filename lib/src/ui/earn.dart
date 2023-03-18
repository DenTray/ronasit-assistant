import './shared/refresh_button.dart';
import './../support/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './shared/cupertino_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/blocs/earn/earn_bloc.dart';
import 'package:ronas_assistant/src/blocs/earn/earn_state.dart';
import 'package:ronas_assistant/src/blocs/earn/events/fetch_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/refresh_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/change_displayed_currency_event.dart';

class Earn extends StatefulWidget {
  const Earn({Key? key}) : super(key: key);

  @override
  State<Earn> createState() => _EarnState();
}

class _EarnState extends State<Earn> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EarnBloc()..add(FetchEarnEvent()),
      child: BlocBuilder<EarnBloc, EarnState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarStats)),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                chooseCurrencyButton(state.isLoading, state.displayedCurrency?.name ?? '', state.currenciesNames, state.exchangeRate, context.read<EarnBloc>()),
                earnContent(state.isLoading, state.formattedTodayEarned, state.formattedWeekEarned, state.formattedMonthEarned),
                refreshButton(state.isLoading, state.refreshIconAngle, context.read<EarnBloc>())
              ]
            )
          );
        }
      )
    );
  }

  Widget chooseCurrencyButton(bool isLoading, String currencyName, List<String> currencies, double quote, bloc) {
    return AnimatedOpacity(
      opacity: (isLoading) ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: () => UIHelpers.displayCupertinoDialog(context, CupertinoDialog(
            fontSize: 15,
            items: currencies,
            currentItem: currencyName,
            onSelectedItemChangedCallback: (index) => bloc.add(ChangeDisplayedCurrencyEvent(index))
        )),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          fixedSize: MaterialStateProperty.all(const Size.fromWidth(260))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AutoSizeText.rich(
                TextSpan(text: currencyName),
                style: const TextStyle(fontSize: 15),
                minFontSize: 1,
                maxLines: 1,
              )
            ),
            Text('(${quote.toStringAsFixed(2)})'),
            const Icon(Icons.arrow_drop_down)
          ]
        )
      )
    );
  }

  Widget refreshButton(bool isLoading, double refreshIconAngle, bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RefreshButton(
          callback: () => bloc.add(RefreshEarnEvent()),
          isProcessing: isLoading,
          refreshIconAngle: refreshIconAngle
        )
      ]
    );
  }

  Widget earnContent(bool isLoading, String todayEarned, String weekEarned, String monthEarned) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppLocalizations.of(context)!.textToday}:'),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            Text('${AppLocalizations.of(context)!.textWeek}:'),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            Text('${AppLocalizations.of(context)!.textMonth}:')
          ],
        ),
        const Padding(padding: EdgeInsets.only(left: 20, right: 20)),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            amount(isLoading, todayEarned),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            amount(isLoading, weekEarned),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            amount(isLoading, monthEarned)
          ]
        )
      ]
    );
  }

  Widget amount(bool isLoading, String formatterAmount) {
    return Text(
      formatterAmount,
      style: TextStyle(color: (isLoading) ? Colors.grey : Colors.black)
    );
  }
}