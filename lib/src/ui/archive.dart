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
import 'package:ronas_assistant/src/blocs/archive/events/sorting_button_clicked_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/sorting_window_state_changed_event.dart';
import 'package:ronas_assistant/src/models/archive_statistic.dart';
import 'package:ronas_assistant/src/support/ui_helpers.dart';
import '../blocs/archive/archive_bloc.dart';
import '../blocs/archive/archive_state.dart';
import '../blocs/archive/events/apply_sort_event.dart';
import '../blocs/archive/events/hide_sorting_window_event.dart';
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
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.appBarArchive),
              actions: [
                IconButton(
                  onPressed: () => context.read<ArchiveBloc>().add(SortingButtonClickedEvent()),
                  icon: const Icon(Icons.sort)
                )
              ],
            ),
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    datePicker(context.read<ArchiveBloc>(), state.fromDate, state.toDate, state.isLoading, state.isCustomModeEnabled),
                    const Divider(),
                    (!state.isLoading) ? aggregations(context.read<ArchiveBloc>(), state.statistic!, state.earned) : const SizedBox(),
                    (state.isLoading) ? const Padding(padding: EdgeInsets.only(top: 200)) : const Divider(),
                    (state.isLoading)
                        ? const CircularProgressIndicator()
                        : archiveContent(state.statistic!, state.earned),
                  ]
                ),
                sortMenu(context.read<ArchiveBloc>(), state.isSortingWindowStateChanging, state.isSortingWindowOpened, state.sortingIndex)
              ]
            )
          );
        }
      )
    );
  }

  Widget sortMenu(ArchiveBloc bloc, bool isSortingWindowStateChanging, bool isSortingWindowOpened, int sortingItemIndex) {
    return TapRegion(
      onTapOutside: (tap) => bloc.add(HideSortingWindowEvent()),
      child: AnimatedOpacity(
        opacity: isSortingWindowStateChanging ? 1 : 0,
        onEnd: () => bloc.add(SortingWindowStateChangedEvent()),
        duration: const Duration(milliseconds: 200),
        child: Visibility(
          visible: isSortingWindowOpened,
          child: Align(
            alignment: Alignment.topRight,
            child: Card(
              child: SizedBox(
                height: 200,
                width: 190,
                child: Column(
                  children: [
                    sortOption(bloc, AppLocalizations.of(context)!.buttonSortProjectAZ, 0, sortingItemIndex),
                    sortOption(bloc, AppLocalizations.of(context)!.buttonSortProjectZA, 1, sortingItemIndex),
                    sortOption(bloc, AppLocalizations.of(context)!.buttonSortTimeAZ, 2, sortingItemIndex),
                    sortOption(bloc, AppLocalizations.of(context)!.buttonSortTimeZA, 3, sortingItemIndex),
                  ]
                )
              )
            )
          )
        )
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(padding: EdgeInsets.only(right: 10)),
        dateButton(bloc, fromDate, isLoading, true, isCustomModeEnabled),
        const Text(' - '),
        dateButton(bloc, toDate, isLoading, false, isCustomModeEnabled),
        IconButton(
          onPressed: () => _showActionSheet(context, bloc),
          icon: const Icon(Icons.arrow_drop_down)
        ),
      ]
    );
  }

  Widget archiveContent(ArchiveStatistic statistic, double earned) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          padding: const EdgeInsets.all(15),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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

  Widget sortOption(ArchiveBloc bloc, String label, int index, int currentSortingIndex) {
    return OutlinedButton(
      onPressed: () => bloc.add(ApplySortEvent(index)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(style: BorderStyle.none),
        fixedSize: Size(MediaQuery.of(context).size.width, 44)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Opacity(opacity: (index == currentSortingIndex) ? 1 : 0, child: const Icon(Icons.done))
        ]
      )
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