import 'package:flutter/material.dart';

import '../excel_data.dart';
import 'divider.dart';
import 'row_widget.dart';

class LockedExcelRowWidget extends StatelessWidget {
  const LockedExcelRowWidget({
    Key? key,
    required this.row,
    required this.columnWidth,
    this.end = 0,
    this.onTapped,
    this.padding,
    this.dividerColor,
  }) : super(key: key);
  final List<double> columnWidth;
  final ExcelRow row;
  final int end;
  final Color? dividerColor;
  final EdgeInsets? padding;
  final Function(ExcelRow)? onTapped;

  @override
  Widget build(BuildContext context) {
    final listSubRow = row.listSubRow;

    final colWidth = columnWidth.getRange(0, end);
    final padHoz = padding?.horizontal ?? 8.0;
    final allWidth = colWidth.reduce((v, e) => v + e + padHoz) + padHoz;
    final showSubRow =
        row.showSubRow && listSubRow != null && listSubRow.isNotEmpty;
    final mainRow = ExcelRowWidget(
      listCell: row.listCell.getRange(0, end),
      columnWidth: colWidth,
      padding: padding,
    );
    final divider = MainDivider(color: dividerColor, width: allWidth);
    return GestureDetector(
      onTap: () => onTapped?.call(row),
      child: showSubRow
          ? Column(
              children: List.generate(
                  listSubRow!.length,
                  (index) => ExcelRowWidget(
                        listCell: listSubRow[index].listCell.getRange(0, end),
                        columnWidth: colWidth,
                        padding: padding,
                      ))
                ..add(divider)
                ..insert(0, mainRow),
            )
          : Column(
              children: [mainRow, divider],
            ),
    );
  }
}
