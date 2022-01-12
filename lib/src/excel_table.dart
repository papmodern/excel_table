import 'package:excel_table/excel_table.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

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
  final Color headerBackgroudColor;

  /// Add a divider widget on each row of locked area
  final Widget Function(BuildContext context, double width)? lockedDivider;

  /// Add a divider widget on each row of scroll area
  final Widget Function(BuildContext context, double width)? scrollableDivider;

  /// Add an effect on the right of the scroll area
  final Widget Function(BuildContext context, bool atRight)? onRightEffect;

  /// Add an effect on the left of the scroll area
  final Widget Function(BuildContext, bool atLeft)? onLeftEffect;

  /// Add an widget at the bottom of table
  final Widget Function(BuildContext)? footerBuilder;

  /// Add widget builder for empty cell
  /// If it is null and default return a sizebox
  final WidgetBuilder? emptyCellBuilder;

  const ExcelTable({
    Key? key,
    required this.data,
    required this.headers,
    required this.minColumnsWidth,
    this.lockedColumn = 1,
    this.scrollController,
    this.headerStyle,
    this.padding,
    this.lockedDivider,
    this.scrollableDivider,
    this.onRightEffect,
    this.onLeftEffect,
    this.footerBuilder,
    this.headerBackgroudColor = Colors.blue,
    this.emptyCellBuilder,
  }) : super(key: key);

  @override
  _ExcelTableState createState() => _ExcelTableState();
}

class _ExcelTableState extends State<ExcelTable> {
  late List<double> columnWidth;
  late ScrollController scrollController;
  late ScrollController headScrollController;
  bool atBottom = false, atTop = true;

  late LinkedScrollControllerGroup _controllers;

  @override
  void initState() {
    _controllers = LinkedScrollControllerGroup();
    scrollController = widget.scrollController ?? _controllers.addAndGet();
    headScrollController = _controllers.addAndGet();
    columnWidth = _getColWith();
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
    headScrollController.dispose();
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
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: MyHeader(
            widget,
            columnWidth,
            lockedColumn,
            headScrollController,
          ),
          floating: true,
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
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
                                lockedDivider: widget.lockedDivider,
                              );
                            }),
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
                                      children:
                                          List.generate(rowLength, (index) {
                                        final excelRow =
                                            widget.data.listRow[index];
                                        return ScrollableExcelRowWidget(
                                          row: excelRow,
                                          start: lockedColumn,
                                          columnWidth: columnWidth,
                                          padding: widget.padding,
                                          scrollableDivider:
                                              widget.scrollableDivider,
                                          emptyCellBuilder:
                                              widget.emptyCellBuilder,
                                          onTapped: (row) => _onTappedRow(row),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 12,
                              child: widget.onRightEffect != null
                                  ? widget.onRightEffect!.call(context, atTop)
                                  : _TopEffect(atTop: atTop),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.footerBuilder != null)
                    widget.footerBuilder!.call(context),
                ],
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: widget.onLeftEffect != null
                      ? widget.onLeftEffect!.call(context, atBottom)
                      : _BottomEffect(atBottom: atBottom))
            ],
          ),
        )
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

class MyHeader extends SliverPersistentHeaderDelegate {
  final ExcelTable widget;
  final List<double> columnWidth;
  final int lockedColumn;
  final ScrollController scrollController;

  MyHeader(
    this.widget,
    this.columnWidth,
    this.lockedColumn,
    this.scrollController,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Row(
      children: [
        LockedHeaderWidget(
          listHeaders: widget.headers,
          columnWidth: columnWidth,
          padding: widget.padding,
          end: lockedColumn,
          headerColor: widget.headerBackgroudColor,
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: ScrollableHeaderWidget(
              listHeaders: widget.headers,
              columnWidth: columnWidth,
              padding: widget.padding,
              start: lockedColumn,
              headerColor: widget.headerBackgroudColor,
            ),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 40;

  @override
  // TODO: implement minExtent
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _BottomEffect extends StatelessWidget {
  const _BottomEffect({
    Key? key,
    required this.atBottom,
  }) : super(key: key);

  final bool atBottom;

  @override
  Widget build(BuildContext context) {
    return Visibility(
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
    );
  }
}

class _TopEffect extends StatelessWidget {
  const _TopEffect({
    Key? key,
    required this.atTop,
  }) : super(key: key);

  final bool atTop;

  @override
  Widget build(BuildContext context) {
    return Visibility(
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
    );
  }
}
