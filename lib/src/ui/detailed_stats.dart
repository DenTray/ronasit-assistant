import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ronas_assistant/src/models/report.dart';
import 'package:ronas_assistant/src/support/types/time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailedStats extends StatefulWidget {
  final List<Report> reports;
  final String period;

  const DetailedStats({
    Key? key,
    required this.reports,
    required this.period,
  }) : super(key: key);

  @override
  State<DetailedStats> createState() => _DetailedStatsState();
}

class _DetailedStatsState extends State<DetailedStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${AppLocalizations.of(context)!.appBarStats}: ${widget.period}')),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: widget.reports.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          Report report = widget.reports[index];

          return Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText.rich(
                    TextSpan(text: report.project),
                    style: const TextStyle(fontSize: 15),
                    minFontSize: 1,
                    maxLines: 1,
                  )
                ),
                Text(Time.fromDouble(hours: report.hours).toString()),
              ],
            )
          );
        }
      )
    );
  }
}