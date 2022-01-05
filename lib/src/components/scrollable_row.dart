import 'package:flutter/widgets.dart';

import '../excel_data.dart';
import 'divider.dart';
import 'row_widget.dart';

class ScrollableExcelRowWidget extends StatelessWidget {
  const ScrollableExcelRowWidget({
    Key? key,
    required this.columnWidth,
    required this.row,
    this.start = 0,
    this.padding,
    this.onTapped,
    this.scrollableDivider,
    this.emptyCellBuilder,
  }) : super(key: key);
  final List<double> columnWidth;
  final ExcelRow row;
  final int start;

  final EdgeInsets? padding;
  final Function(ExcelRow)? onTapped;
  final Widget Function(BuildContext, double)? scrollableDivider;
  final WidgetBuilder? emptyCellBuilder;

  @override
  Widget build(BuildContext context) {
    final listSubRow = row.listSubRow;
    final end = columnWidth.length;
    final colWidth = columnWidth.getRange(start, columnWidth.length);
    final padHoz = padding?.horizontal ?? 8.0;
    final allWidth = colWidth.reduce((v, e) => v + e + padHoz) + padHoz;
    final showSubRow =
        row.showSubRow && listSubRow != null && listSubRow.isNotEmpty;
    final mainRow = ExcelRowWidget(
      listCell: row.listCell.getRange(start, end),
      columnWidth: colWidth,
      padding: padding,
      emptyCellBuilder: emptyCellBuilder,
    );
    final divider = scrollableDivider?.call(context, allWidth) ??
        MainDivider(width: allWidth);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTapped?.call(row),
      child: showSubRow
          ? Column(
              children: List.generate(
                  listSubRow!.length,
                  (index) => ExcelRowWidget(
                        listCell:
                            listSubRow[index].listCell.getRange(start, end),
                        columnWidth: colWidth,
                        padding: padding,
                        emptyCellBuilder: emptyCellBuilder,
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
