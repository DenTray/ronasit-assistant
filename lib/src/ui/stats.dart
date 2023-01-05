import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronas_assistant/src/support/types/time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/ui/shared/refresh_button.dart';
import 'package:ronas_assistant/src/blocs/stats/statistic_bloc.dart';
import 'package:ronas_assistant/src/blocs/stats/statistic_state.dart';
import 'package:ronas_assistant/src/blocs/stats/events/fetch_statistic_event.dart';
import 'package:ronas_assistant/src/blocs/stats/events/set_remain_mode_event.dart';
import 'package:ronas_assistant/src/blocs/stats/events/refresh_statistic_event.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  String getTimeSign(Time? time) {
    return (time != null && !time.isPositive) ? '+' : '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticBloc()..add(FetchStatisticEvent()),
      child: BlocBuilder<StatisticBloc, StatisticState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarStats)),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                remainModeSwitcher([!state.isRemainModeEnabled, state.isRemainModeEnabled], (int index) {
                  context.read<StatisticBloc>().add(SetRemainModeEvent(index == 1));
                }),
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                contributionRequiredLabel(state.isContributionRequired),
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                (state.statistic == null) ? const CircularProgressIndicator() : statsBlock(state),
                const Padding(padding: EdgeInsets.only(top: 50)),
                refreshButtonLine(state.isLoading, state.refreshIconAngle, () {
                  context.read<StatisticBloc>().add(RefreshStatisticEvent());
                })
              ]
            )
          );
        }
      )
    );
  }

  Widget statsBlock(StatisticState state) {
    return Row(
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
          ]
        ),
        const Padding(padding: EdgeInsets.only(left: 20, right: 20)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black),
              (state.isRemainModeEnabled)
                ? '${getTimeSign(state.todayRemainTime)}${state.todayRemainTime.toString()}'
                : '${state.todayTime.toString()}/${state.dayPlan.toString()}',
            ),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            Text(
              style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black),
              (state.isRemainModeEnabled)
                ? '${getTimeSign(state.weekRemainTime)}${state.weekRemainTime.toString()}'
                : '${state.weekTime.toString()}/${state.weekPlan}',
            ),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            Text(
              style: TextStyle(color: (state.isLoading) ? Colors.grey : Colors.black),
              (state.isRemainModeEnabled)
                ? '${getTimeSign(state.monthRemainTime)}${state.monthRemainTime.toString()}'
                : '${state.monthTime}/${state.monthPlan}',
            )
          ]
        ),
        const Padding(padding: EdgeInsets.only(left: 20, right: 20)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            completeIcon(state.todayTime.gte(state.dayPlan.toDouble())),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            completeIcon(state.weekTime.gte(state.weekPlan.toDouble())),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            completeIcon(state.monthTime.gte(state.monthPlan.toDouble()))
          ]
        )
      ]
    );
  }

  Widget remainModeSwitcher(List<bool> isSelected, void Function(int) onSwitchCallback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ToggleButtons(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.blue[700],
          selectedColor: Colors.white,
          fillColor: Colors.blue[200],
          color: Colors.blue[400],
          constraints: const BoxConstraints(minHeight: 20, minWidth: 130),
          onPressed: onSwitchCallback,
          isSelected: isSelected,
          children: [
            Text(AppLocalizations.of(context)!.buttonEnableRemainMode, style: const TextStyle(fontSize: 15)),
            Text(AppLocalizations.of(context)!.buttonDisableRemainMode, style: const TextStyle(fontSize: 15))
          ],
        ),
      ]
    );
  }

  Widget contributionRequiredLabel(bool shouldBeDisplayed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Opacity(
          opacity: (shouldBeDisplayed) ? 1 : 0,
          child: Text(AppLocalizations.of(context)!.messageContributionRequired, style: const TextStyle(
            color: Colors.red,
            fontSize: 12
          ))
        )
      ]
    );
  }

  Widget refreshButtonLine(bool isProcessing, iconAngle, callback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RefreshButton(isProcessing: isProcessing, refreshIconAngle: iconAngle, callback: callback)
      ]
    );
  }

  Widget completeIcon(bool isVisible) {
    return Opacity(
      opacity: (isVisible) ? 1 : 0,
      child: const Icon(Icons.done, color: Colors.lightGreen)
    );
  }
}