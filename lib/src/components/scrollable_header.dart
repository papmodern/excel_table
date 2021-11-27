import 'package:flutter/widgets.dart';

import 'header_widget.dart';

class ScrollableHeaderWidget extends StatelessWidget {
  final List<double> columnWidth;
  final List<Widget> listHeaders;
  final EdgeInsets? padding;
  final int start;

  const ScrollableHeaderWidget(
      {Key? key,
      required this.columnWidth,
      required this.listHeaders,
      this.padding,
      required this.start})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final end = listHeaders.length;
    return ExcelHeaderWidget(
        listHeaders: listHeaders.getRange(start, end),
        columnWidth: columnWidth.getRange(start, end));
  }
}
