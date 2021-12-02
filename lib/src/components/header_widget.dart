import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExcelHeaderWidget extends StatelessWidget {
  const ExcelHeaderWidget({
    Key? key,
    required this.listHeaders,
    required this.columnWidth,
    required this.backgroundColor,
    this.padding,
  }) : super(key: key);
  final Color backgroundColor;
  final Iterable<double> columnWidth;
  final Iterable<Widget> listHeaders;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Row(
          children: List.generate(listHeaders.length, (index) {
        final header = listHeaders.elementAt(index);
        final padHoz = padding?.horizontal ?? 8.0;
        final width = columnWidth.elementAt(index) + padHoz;
        return SizedBox(width: width, child: header);
      })),
    );
  }
}
