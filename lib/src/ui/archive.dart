import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ronas_assistant/src/blocs/archive/events/base_archive_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/change_date_from_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/change_date_to_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/choose_custom_range_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/fetch_archive_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/range_events/choose_last_year_range_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/range_events/choose_yesterday_range_event.dart';
import 'package:ronas_assistant/src/models/archive_statistic.dart';
import 'package:ronas_assistant/src/support/ui_helpers.dart';
import 'package:ronas_assistant/src/ui/shared/network_button.dart';
import '../blocs/archive/archive_bloc.dart';
import '../blocs/archive/archive_state.dart';
import '../blocs/archive/events/range_events/choose_last_month_range_event.dart';
import '../blocs/archive/events/range_events/choose_last_week_range_event.dart';
import '../blocs/archive/events/range_events/choose_this_year_range_event.dart';
import '../support/types/time.dart';

class Archive extends StatefulWidget {
  const Archive({Key? key}) : super(key: key);

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArchiveBloc()..add(FetchArchiveEvent()),
      child: BlocBuilder<ArchiveBloc, ArchiveState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarArchive)),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                datePicker(context.read<ArchiveBloc>(), state.fromDate, state.toDate, state.isLoading, state.isCustomModeEnabled),
                (!state.isLoading) ? aggregations(context.read<ArchiveBloc>(), state.statistic!, state.earned) : SizedBox(),
                Divider(),
                (state.isLoading) ? CircularProgressIndicator() : archiveContent(state.statistic!, state.earned),
                Divider(),
                fetchButton(context.read<ArchiveBloc>(), state.isLoading)
              ]
            )
          );
        }
      )
    );
  }

  Widget aggregations(ArchiveBloc bloc, ArchiveStatistic statistic, double earned) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            const Icon(Icons.money),
            Text(earned.roundToDouble().toString())
          ]
        ),
        Row(
          children: [
            const Icon(Icons.bar_chart),
            Text('${statistic.totalHours}/${statistic.totalPlan}')
          ]
        ),
      ],
    );
  }

  Widget dateButton(ArchiveBloc bloc, DateTime date, bool isLoading, bool isFromDate, bool isCustomModeEnabled) {
    return RichText(
      text: TextSpan(
        text: DateFormat.yMMMd('ru_RU').format(date),
        style: TextStyle(fontSize: 20, fontFamily: 'SourceSerif', fontWeight: FontWeight.bold, color: (isLoading || !isCustomModeEnabled) ? Colors.grey : Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = (isLoading || !isCustomModeEnabled) ? null : () {
          UIHelpers.displayCupertinoDialog(context, CupertinoDatePicker(
            initialDateTime: date,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDate) {
              BaseArchiveEvent event = (isFromDate) ? ChangeDateFromEvent(newDate) : ChangeDateToEvent(newDate);
              bloc.add(event);
            }
          ));
        }
      )
    );
  }

  Widget datePicker(ArchiveBloc bloc, DateTime fromDate, DateTime toDate, bool isLoading, bool isCustomModeEnabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        dateButton(bloc, fromDate, isLoading, true, isCustomModeEnabled),
        const Text(' - '),
        dateButton(bloc, toDate, isLoading, false, isCustomModeEnabled)
      ]
    );
  }

  Widget archiveContent(ArchiveStatistic statistic, double earned) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: statistic.projects.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText.rich(
                  TextSpan(text: statistic.projects[index].project),
                  style: const TextStyle(fontSize: 17),
                  minFontSize: 1,
                  maxLines: 1,
                ),
                Text(Time.fromDouble(hours: statistic.projects[index].hours).toString()),
              ]
            );
          }
        )
      )
    );
  }

  Widget fetchButton(ArchiveBloc bloc, bool isProcessing) {
    return NetworkButton(
      callback: () => _showActionSheet(context, bloc),
      icon: Icons.access_time,
      text: AppLocalizations.of(context)!.buttonRange,
      isProcessing: isProcessing
    );
  }

  void _showActionSheet(BuildContext context, ArchiveBloc bloc) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context)!.textChoosePeriod),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.buttonDateRangeYesterday),
            onPressed: () {
              bloc.add(ChooseYesterdayRangeEvent());
              Navigator.pop(context);
            }
          ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.buttonDateRangeLastWeek),
            onPressed: () {
              bloc.add(ChooseLastWeekRangeEvent());
              Navigator.pop(context);
            }
          ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.buttonDateRangeLastMonth),
            onPressed: () {
              bloc.add(ChooseLastMonthRangeEvent());
              Navigator.pop(context);
            }
          ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.buttonDateRangeThisYear),
            onPressed: () {
              bloc.add(ChooseThisYearRangeEvent());
              Navigator.pop(context);
            }
          ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.buttonDateRangeLastYear),
            onPressed: () {
              bloc.add(ChooseLastYearRangeEvent());
              Navigator.pop(context);
            }
          ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.buttonDateRangeCustom),
            onPressed: () {
              bloc.add(ChooseCustomRangeEvent());
              Navigator.pop(context);
            }
          )
        ]
      )
    );
  }
}