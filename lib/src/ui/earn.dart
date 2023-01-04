import './shared/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/blocs/earn/earn_bloc.dart';
import 'package:ronas_assistant/src/blocs/earn/earn_state.dart';
import 'package:ronas_assistant/src/blocs/earn/events/fetch_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/refresh_earn_event.dart';

class Earn extends StatefulWidget {
  const Earn({Key? key}) : super(key: key);

  @override
  State<Earn> createState() => _EarnState();
}

class _EarnState extends State<Earn> {
  final String _currency = '\$';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EarnBlock()..add(FetchEarnEvent()),
      child: BlocBuilder<EarnBlock, EarnState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarStats)),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${AppLocalizations.of(context)!.textToday}:'),
                        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                        Text('${AppLocalizations.of(context)!.textWeek}:'),
                        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                        Text('${AppLocalizations.of(context)!.textMonth}:'),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(left: 20, right: 20)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${state.todayEarned.toStringAsFixed(2)}$_currency (${state.todayEarnedRub.toStringAsFixed(2)} руб.)',
                          style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black)
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                        Text(
                          '${state.weekEarned.toStringAsFixed(2)}$_currency (${state.weekEarnedRub.toStringAsFixed(2)} руб.)',
                          style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black)
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                        Text(
                          '${state.monthEarned.toStringAsFixed(2)}$_currency (${state.monthEarnedRub.toStringAsFixed(2)} руб.)',
                          style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black)
                        )
                      ]
                    )
                  ]
                ),
                const Padding(padding: EdgeInsets.only(top: 50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RefreshButton(callback: () => context.read<EarnBlock>().add(RefreshEarnEvent()), isProcessing: state.isLoading, refreshIconAngle: state.refreshIconAngle)
                  ]
                )
              ]
            )
          );
        }
      )
    );
  }
}