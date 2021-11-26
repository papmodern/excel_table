import 'package:flutter/material.dart';

import 'package:excel_table/excel_table.dart';

class ExcelTable extends StatefulWidget {
  final ExcelData data;
  final int lockedColumn;
  final List<String> header;
  const ExcelTable({
    Key? key,
    required this.data,
    this.lockedColumn = 1,
    required this.header,
  }) : super(key: key);

  @override
  _ExcelTableState createState() => _ExcelTableState();
}

class _ExcelTableState extends State<ExcelTable> {
  late List<double> columnWidth;

  @override
  void initState() {
    columnWidth = widget.data.columnsWidth;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExcelTable oldWidget) {
    print('didUpdateWidget');
    columnWidth = widget.data.columnsWidth;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          height: 10,
          color: Colors.red,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.data.listRow.length, (index) {
                final excelRow = widget.data.listRow[index];
                return ExcelRowWidget(
                    row: excelRow,
                    startCol: widget.lockedColumn,
                    columnWidth: columnWidth);
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class ExcelRowWidget extends StatelessWidget {
  const ExcelRowWidget({
    Key? key,
    required this.row,
    required this.columnWidth,
    this.startCol = 0,
  }) : super(key: key);
  final List<double> columnWidth;
  final ExcelRow row;
  final int startCol;

  @override
  Widget build(BuildContext context) {
    final showSubRow = row.showSubRow;
    if (showSubRow) {
      return Column();
    }
    return _ExcelRowWidget(
      listCell: row.listCell,
      columnWidth: columnWidth,
      startCol: startCol,
    );
  }
}

class _ExcelRowWidget extends StatelessWidget {
  const _ExcelRowWidget({
    Key? key,
    required this.listCell,
    required this.columnWidth,
    required this.startCol,
  }) : super(key: key);
  final List<double> columnWidth;
  final int startCol;
  final List<ExcelCell> listCell;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(listCell.length - startCol, (index) {
        final cell = listCell[index + startCol];
        final width = columnWidth[index + startCol];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            color: Colors.green,
            width: width,
            child: cell.child ??
                Text(
                  cell.content!,
                  style: cell.style,
                ),
          ),
        );
      }),
    );
  }
}
