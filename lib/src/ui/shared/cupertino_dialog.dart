import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CupertinoDialog extends StatefulWidget {
  final void Function(int) onSelectedItemChangedCallback;
  final List items;
  final dynamic currentItem;

  const CupertinoDialog({
    Key? key,
    required this.onSelectedItemChangedCallback,
    required this.items,
    required this.currentItem
  }) : super(key: key);

  @override
  State<CupertinoDialog> createState() => _CupertinoDialogState();
}

class _CupertinoDialogState extends State<CupertinoDialog> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: widget.items.indexOf(widget.currentItem)),
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32.0,
        onSelectedItemChanged: widget.onSelectedItemChangedCallback,
        children: List<Widget>.generate(
          widget.items.length, (int index) {
            var item = widget.items[index];

            if (item.runtimeType != String) {
              item = item.toString();
            }

            return Center(child: Text(item));
          }
        )
    );
  }
}