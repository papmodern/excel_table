import 'package:flutter/material.dart';

import '../excel_data.dart';

class ExcelRowWidget extends StatelessWidget {
  const ExcelRowWidget({
    Key? key,
    required this.listCell,
    required this.columnWidth,
    this.padding,
  }) : super(key: key);
  final Iterable<double> columnWidth;
  final Iterable<ExcelCell> listCell;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(listCell.length, (index) {
        final cell = listCell.elementAt(index);
        final width = columnWidth.elementAt(index);
        return Padding(
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          child: SizedBox(
            width: width,
            child: cell.child ??
                Text(
                  cell.content!,
                  textAlign: cell.align,
                  style: cell.style,
                ),
          ),
        );
      }),
    );
  }
}
