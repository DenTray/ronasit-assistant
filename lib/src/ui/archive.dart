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
import 'package:ronas_assistant/src/blocs/archive/events/fetch_archive_event.dart';
import 'package:ronas_assistant/src/models/archive_statistic.dart';
import 'package:ronas_assistant/src/support/ui_helpers.dart';
import 'package:ronas_assistant/src/ui/shared/network_button.dart';
import '../blocs/archive/archive_bloc.dart';
import '../blocs/archive/archive_state.dart';
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    datePicker(context.read<ArchiveBloc>(), state.fromDate, state.toDate, state.isLoading),
                    const Padding(padding: EdgeInsets.all(10)),
                    (state.isLoading) ? CircularProgressIndicator() : archiveContent(state.statistic!, state.earned),
                  ]
                ),
                fetchButton(context.read<ArchiveBloc>(), state.isLoading)
              ]
            )
          );
        }
      )
    );
  }

  Widget dateButton(ArchiveBloc bloc, DateTime date, bool isLoading, bool isFromDate) {
    return RichText(
      text: TextSpan(
        text: DateFormat.yMMMd('ru_RU').format(date),
        style: TextStyle(fontSize: 20, fontFamily: 'SourceSerif', fontWeight: FontWeight.bold, color: (isLoading) ? Colors.grey : Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = () {
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

  Widget datePicker(ArchiveBloc bloc, DateTime fromDate, DateTime toDate, bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        dateButton(bloc, fromDate, isLoading, true),
        const Text(' - '),
        dateButton(bloc, toDate, isLoading, false)
      ]
    );
  }

  Widget archiveContent(ArchiveStatistic statistic, double earned) {
    List<Widget> items = [Text('${statistic.totalHours}/${statistic.totalPlan}')];
    items.add(Text(earned.roundToDouble().toString()));

    statistic.projects.forEach((element) {
      Widget projectNameText = AutoSizeText.rich(
        TextSpan(text: element.project),
        style: const TextStyle(fontSize: 17),
        minFontSize: 1,
        maxLines: 1,
      );

      items.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          projectNameText,
          Text(Time.fromDouble(hours: element.hours).toString()),
        ],
      ));
    });

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: items
      )
    );
  }

  Widget fetchButton(ArchiveBloc bloc, bool isProcessing) {
    return NetworkButton(
      callback: () => bloc.add(FetchArchiveEvent()),
      icon: Icons.upload,
      text: 'Get archive data',
      loadingText: 'Getting archive data...',
      isProcessing: isProcessing
    );
  }
}