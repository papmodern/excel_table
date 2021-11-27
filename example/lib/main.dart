import 'package:flutter/material.dart';

import 'package:excel_table/excel_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ExcelData data;
  @override
  void initState() {
    super.initState();
    final excelRow1 = ExcelRow(listCell: [
      ExcelCell(content: "PVBF", align: TextAlign.start),
      ExcelCell(content: "40%"),
      ExcelCell(content: "10.020.000đ"),
      ExcelCell(content: "18.890đ"),
      ExcelCell(content: "01/02/2021"),
    ], listSubRow: [
      ExcelRow(
        listCell: [
          ExcelCell.empty(),
          ExcelCell(content: "30%"),
          ExcelCell(content: "10.020.000đ"),
          ExcelCell(content: "18.890đ"),
          ExcelCell(content: "01/02/2021"),
        ],
      ),
      ExcelRow(listCell: [
        ExcelCell.empty(),
        ExcelCell(content: "10%"),
        ExcelCell(content: "10.020.000đ"),
        ExcelCell(content: "18.890đ"),
        ExcelCell(content: "01/02/2021"),
      ]),
    ]);
    final excelRow2 = ExcelRow(listCell: [
      ExcelCell(content: "SSIBF", align: TextAlign.start),
      ExcelCell(content: "10%"),
      ExcelCell(content: "10.020.000đ"),
      ExcelCell(content: "18.890đ"),
      ExcelCell(content: "01/02/2021"),
    ]);

    data = ExcelData(
        listRow: [excelRow1, excelRow2],
        initWidth: [120, null, null, null, null]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Excel Table'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ExcelTable(
                  data: data,
                  lockedColumn: 1,
                  headers: const [
                    HeaderWidget(
                      "Qũy",
                      alignment: Alignment.centerLeft,
                    ),
                    HeaderWidget("Phân bổ"),
                    HeaderWidget("Khớp lệnh"),
                    HeaderWidget("Thực nhận"),
                    HeaderWidget(
                      "Thời gian",
                      alignment: Alignment.centerRight,
                    )
                  ],
                  minColumnsWidth: const [60, 70, 80, 80, 80],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final AlignmentGeometry alignment;
  final String title;
  const HeaderWidget(
    this.title, {
    Key? key,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      color: const Color(0xFF00B14F),
      child: Align(
        alignment: alignment,
        child: Text(
          title,
        ),
      ),
    );
  }
}
