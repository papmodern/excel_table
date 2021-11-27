import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:excel_table/excel_table.dart';

import 'components/locked_header.dart';
import 'components/locked_row.dart';
import 'components/scrollable_header.dart';
import 'components/scrollable_row.dart';

class ExcelTable extends StatefulWidget {
  final ExcelData data;
  final int lockedColumn;
  final List<Widget> headers;
  final List<double> minColumnsWidth;
  final ScrollController? scrollController;
  final TextStyle? headerStyle;
  final EdgeInsets? padding;
  final Color? dividerColor;
  const ExcelTable({
    Key? key,
    required this.data,
    required this.headers,
    required this.minColumnsWidth,
    this.lockedColumn = 1,
    this.scrollController,
    this.headerStyle,
    this.padding,
    this.dividerColor,
  }) : super(key: key);

  @override
  _ExcelTableState createState() => _ExcelTableState();
}

class _ExcelTableState extends State<ExcelTable> {
  late List<double> columnWidth;
  late ScrollController scrollController;
  bool atBottom = false, atTop = true;

  @override
  void initState() {
    columnWidth = _getColWith();
    scrollController = widget.scrollController ?? ScrollController();
    scrollController.addListener(() => onScroll());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExcelTable oldWidget) {
    columnWidth = _getColWith();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  List<double> _getColWith() {
    final headersWidth = widget.minColumnsWidth;
    final contentsWidth = widget.data.columnsWidth;

    assert(headersWidth.length == contentsWidth.length,
        'Headers and contents is not equal length');
    for (int i = 0; i < contentsWidth.length; i++) {
      final h = headersWidth[i];
      final c = contentsWidth[i];
      if (h > c) {
        contentsWidth[i] = h;
      }
    }
    return contentsWidth;
  }

  @override
  Widget build(BuildContext context) {
    final rowLength = widget.data.listRow.length;
    final lockedColumn = widget.lockedColumn;
    return Row(
      children: [
        if (lockedColumn > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(rowLength, (index) {
                final excelRow = widget.data.listRow[index];
                return LockedExcelRowWidget(
                  row: excelRow,
                  end: lockedColumn,
                  columnWidth: columnWidth,
                  padding: widget.padding,
                  onTapped: (row) => _onTappedRow(row),
                );
              })
                ..insert(
                    0,
                    LockedHeaderWidget(
                      listHeaders: widget.headers,
                      columnWidth: columnWidth,
                      padding: widget.padding,
                      end: lockedColumn,
                    )),
            ),
          ),
        Expanded(
          child: Stack(
            children: [
              MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: Scrollbar(
                  controller: scrollController,
                  isAlwaysShown: true,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      controller: scrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(rowLength, (index) {
                          final excelRow = widget.data.listRow[index];
                          return ScrollableExcelRowWidget(
                            row: excelRow,
                            start: lockedColumn,
                            columnWidth: columnWidth,
                            padding: widget.padding,
                            onTapped: (row) => _onTappedRow(row),
                          );
                        })
                          ..insert(
                              0,
                              ScrollableHeaderWidget(
                                listHeaders: widget.headers,
                                columnWidth: columnWidth,
                                padding: widget.padding,
                                start: lockedColumn,
                              )),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 12,
                child: Visibility(
                  visible: !atTop,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.black26, Colors.transparent],
                      )),
                      width: 10,
                    ),
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  bottom: 12,
                  child: Visibility(
                    visible: !atBottom,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0x00FFFFFF),
                            Colors.white54,
                          ],
                        )),
                        width: 20,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  _onTappedRow(ExcelRow row) {
    setState(() {
      row.showSubRow = !row.showSubRow;
    });
  }

  onScroll() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels == 0) {
        setState(() {
          atTop = true;
          atBottom = false;
        });
      } else {
        setState(() {
          atBottom = true;
          atTop = false;
        });
      }
    } else {
      if (atTop == true || atBottom == true) {
        setState(() {
          atTop = false;
          atBottom = false;
        });
      }
    }
  }
}
