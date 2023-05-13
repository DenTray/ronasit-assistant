import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronas_assistant/src/models/report.dart';
import 'package:ronas_assistant/src/support/types/time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ronas_assistant/src/ui/detailed_stats.dart';
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
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

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
                remainModeSwitcher(state, context.read<StatisticBloc>()),
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                contributionRequiredLabel(state.isContributionRequired),
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                (state.statistic == null) ? const CircularProgressIndicator() : statsBlock(state),
                const Padding(padding: EdgeInsets.only(top: 50)),
                refreshButtonLine(state, context.read<StatisticBloc>())
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
            time(state, state.todayRemainTime, state.todayTime, state.dayPlan, state.statistic!.reports.today, AppLocalizations.of(context)!.textToday),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            time(state, state.weekRemainTime, state.weekTime, state.weekPlan, state.statistic!.reports.week, AppLocalizations.of(context)!.textWeek),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            time(state, state.monthRemainTime, state.monthTime, state.monthPlan, state.statistic!.reports.month, AppLocalizations.of(context)!.textMonth),
          ]
        ),
        const Padding(padding: EdgeInsets.only(left: 20, right: 20)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (state.todayRemainTime.isPositive) ? finishTime(AppLocalizations.of(context)!.textFinishTime + state.finishTime) : completeIcon(state.todayRemainTime.isNegative || state.todayRemainTime.isEmpty),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            completeIcon(!state.weekRemainTime.isPositive),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            completeIcon(!state.monthRemainTime.isPositive)
          ]
        )
      ]
    );
  }

  Widget remainModeSwitcher(StatisticState state, StatisticBloc bloc) {
    bool isLoaded = state.statistic != null;
    List<bool> isSelected = [!state.isRemainModeEnabled, state.isRemainModeEnabled];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        loadable(isLoaded, ToggleButtons(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.blue[700],
          selectedColor: Colors.white,
          fillColor: Colors.blue[200],
          color: Colors.blue[400],
          constraints: const BoxConstraints(minHeight: 20, minWidth: 130),
          onPressed: (index) => bloc.add(SetRemainModeEvent(index == 1)),
          isSelected: isSelected,
          children: [
            Text(AppLocalizations.of(context)!.buttonEnableRemainMode, style: const TextStyle(fontSize: 15)),
            Text(AppLocalizations.of(context)!.buttonDisableRemainMode, style: const TextStyle(fontSize: 15))
          ]
        ))
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

  Widget refreshButtonLine(StatisticState state, StatisticBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        loadable(state.statistic != null, RefreshButton(
          isProcessing: state.isLoading,
          refreshIconAngle: state.refreshIconAngle,
          callback: () => bloc.add(RefreshStatisticEvent())
        ))
      ]
    );
  }

  Widget completeIcon(bool isVisible) {
    return Opacity(
      opacity: (isVisible) ? 1 : 0,
      child: const Icon(Icons.done, color: Colors.lightGreen)
    );
  }

  Widget finishTime(String message) {
    return Tooltip(
      key: tooltipKey,
      triggerMode: TooltipTriggerMode.manual,
      showDuration: const Duration(seconds: 3),
      message: message,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        onPressed: () => tooltipKey.currentState?.ensureTooltipVisible(),
        splashRadius: 10,
        icon: const Icon(Icons.info_outline))
    );
  }

  Widget loadable(bool isLoaded, Widget child) {
    return AnimatedOpacity(
      opacity: (isLoaded) ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: child
    );
  }

  Widget time(
      StatisticState state,
      Time remainTime,
      Time workedTime,
      Time plan,
      List<Report> reports,
      String period
  ) {
    return RichText(
      text: TextSpan(
        text: (state.isRemainModeEnabled) ? remainTime.toInvertedSignedString() : '$workedTime/${plan.toString()}',
        style: TextStyle(fontSize: 20, fontFamily: 'SourceSerif', fontWeight: FontWeight.bold, color: (state.isLoading) ? Colors.grey : Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedStats(reports: reports, period: period)
            ),
          );
        }
      )
    );
  }
}