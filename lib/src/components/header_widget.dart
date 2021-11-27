import 'package:flutter/widgets.dart';

class ExcelHeaderWidget extends StatelessWidget {
  const ExcelHeaderWidget({
    Key? key,
    required this.listHeaders,
    required this.columnWidth,
    this.padding,
  }) : super(key: key);
  final Iterable<double> columnWidth;
  final Iterable<Widget> listHeaders;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(listHeaders.length, (index) {
      final header = listHeaders.elementAt(index);
      final padHoz = padding?.horizontal ?? 8.0;
      final width = columnWidth.elementAt(index) + padHoz;
      return SizedBox(width: width, child: header);
    }));
  }
}
