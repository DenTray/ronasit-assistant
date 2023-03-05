import './shared/refresh_button.dart';
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
import 'package:ronas_assistant/src/blocs/earn/events/change_currency_event.dart';

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
                ElevatedButton(
                  onPressed: () => _showCupertinoDialog(
                    CupertinoDialog(
                      fontSize: 15,
                      items: state.currenciesNames!,
                      currentItem: state.currency?.name,
                      onSelectedItemChangedCallback: (index) {
                        context.read<EarnBloc>().add(ChangeCurrencyEvent(index));
                      }
                    )
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    fixedSize: MaterialStateProperty.all(const Size.fromWidth(260))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: AutoSizeText.rich(
                        TextSpan(text: state.currency?.name ?? ''),
                        style: const TextStyle(fontSize: 15),
                        minFontSize: 1,
                        maxLines: 1,
                      )),
                      Text('(${state.quote.toStringAsFixed(2)})'),
                      const Icon(Icons.arrow_drop_down),
                    ]
                  )
                ),
                Row(
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
                        Text(
                          state.formattedTodayEarned,
                          style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black)
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                        Text(
                          state.formattedWeekEarned,
                          style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black)
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                        Text(
                          state.formattedMonthEarned,
                          style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black)
                        )
                      ]
                    )
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RefreshButton(callback: () => context.read<EarnBloc>().add(RefreshEarnEvent()), isProcessing: state.isLoading, refreshIconAngle: state.refreshIconAngle)
                  ]
                )
              ]
            )
          );
        }
      )
    );
  }
//TODO move to component
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