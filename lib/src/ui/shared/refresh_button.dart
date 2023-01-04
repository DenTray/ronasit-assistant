import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RefreshButton extends StatefulWidget {
  final void Function() callback;
  final bool isProcessing;
  final double refreshIconAngle;

  const RefreshButton({
    Key? key,
    required this.callback,
    required this.isProcessing,
    required this.refreshIconAngle
  }) : super(key: key);

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: widget.callback,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all((widget.isProcessing) ? Colors.grey : Colors.blue),
            fixedSize: MaterialStateProperty.all(const Size.fromWidth(260))
          ),
          child: Row(
            children: [
              Transform.rotate(
                angle: widget.refreshIconAngle,
                child: const Icon(Icons.refresh)
              ),
              const Padding(padding: EdgeInsets.only(left: 20)),
              Text((widget.isProcessing) ? AppLocalizations.of(context)!.buttonRefreshing : AppLocalizations.of(context)!.buttonRefresh)
            ]
          )
        )
      ]
    );
  }
}