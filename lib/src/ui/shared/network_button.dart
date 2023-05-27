import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NetworkButton extends StatefulWidget {
  final void Function() callback;
  final bool isProcessing;
  final IconData icon;
  final String text;
  final String loadingText;

  const NetworkButton({
    Key? key,
    required this.callback,
    required this.icon,
    required this.isProcessing,
    required this.text,
    required this.loadingText,
  }) : super(key: key);

  @override
  State<NetworkButton> createState() => _NetworkButtonState();
}

class _NetworkButtonState extends State<NetworkButton> {
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
              Icon(widget.icon),
              const Padding(padding: EdgeInsets.only(left: 20)),
              Text((widget.isProcessing) ? widget.loadingText : widget.text)
            ]
          )
        )
      ]
    );
  }
}