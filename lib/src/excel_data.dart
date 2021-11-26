import 'package:flutter/material.dart';

class ExcelCell {
  Widget? child;
  String? content;
  TextStyle? style;
  ExcelCell({
    this.child,
    this.content,
    this.style,
  }) : assert(
          (child == null || content == null),
          'Need at least child or content on Excel Object',
        );
}

class ExcelRow {
  List<ExcelCell> listCell;
  List<ExcelRow>? listSubRow;
  bool showSubRow;
  ExcelRow({
    required this.listCell,
    this.listSubRow,
    this.showSubRow = false,
  });
}

class ExcelData {
  List<ExcelRow> listRow;
  List<double?> initWidth;
  ExcelData({
    required this.listRow,
    required this.initWidth,
  });

  List<double> get columnsWidth => _calulateWidth();

  List<double> _calulateWidth() {
    final result = List.generate(initWidth.length, (i) => 0.0);
    for (int col = 0; col < initWidth.length; col++) {
      ///If with of column is fixed skip
      if (initWidth[col] != null) {
        result[col] = initWidth[col]!;
      } else {
        /// Get maxium text lengh of main row
        for (final row in listRow) {
          final cell = row.listCell[col];
          final textWidth = getCellWidth(cell);
          if (result[col] < textWidth) {
            result[col] = textWidth;
          }
          final listSubRow = row.listSubRow;

          /// If row has sub row and subrow is showed
          /// Calculate subrow too
          if (row.showSubRow && listSubRow != null && listSubRow.isNotEmpty) {
            for (final subRow in listSubRow) {
              final subCell = subRow.listCell[col];
              final subRowTextWidth = getCellWidth(subCell);
              if (result[col] < subRowTextWidth) {
                result[col] = subRowTextWidth;
              }
            }
          }
        }
      }
    }
    return result;
  }
}

double getCellWidth(ExcelCell cell) {
  final content = cell.content;
  final style = cell.style;
  assert(content != null, 'Widget child is not support for dynamic with');
  return _textSize(content!, style).width;
}

Size _textSize(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
