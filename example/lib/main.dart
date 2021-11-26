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
      ExcelCell(content: "PVBF"),
      ExcelCell(content: "40%"),
      ExcelCell(content: "10.020.000đ"),
      ExcelCell(content: "18.890đ"),
      ExcelCell(content: "01/02/2021"),
    ], listSubRow: [
      ExcelRow(
        listCell: [
          ExcelCell(content: "PVBF sub"),
          ExcelCell(content: "30%"),
          ExcelCell(content: "10.020.000đ"),
          ExcelCell(content: "18.890đ"),
          ExcelCell(content: "01/02/2021"),
        ],
      ),
      ExcelRow(listCell: [
        ExcelCell(content: "PVBF sub"),
        ExcelCell(content: "10%"),
        ExcelCell(content: "10.020.000đ"),
        ExcelCell(content: "18.890đ"),
        ExcelCell(content: "01/02/2021"),
      ]),
    ]);
    final excelRow2 = ExcelRow(listCell: [
      ExcelCell(content: "SSIBF"),
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
            ExcelTable(
              data: data,
              header: ["A", "B", "C"],
            ),
            Container(
              color: Colors.blue,
              height: 29,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
