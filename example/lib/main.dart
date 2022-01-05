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
      ExcelCell(content: "Row 1", align: TextAlign.start),
      ExcelCell.empty(),
      ExcelCell.empty(),
      ExcelCell(content: "30%"),
      ExcelCell.empty(),
    ], listSubRow: [
      ExcelRow(
        listCell: [
          ExcelCell(content: ''),
          ExcelCell(content: "30%"),
          ExcelCell.empty(),
          ExcelCell(content: "10.000"),
          ExcelCell.empty(),
        ],
      ),
      ExcelRow(listCell: [
        ExcelCell(content: ''),
        ExcelCell(content: "10%"),
        ExcelCell.empty(),
        ExcelCell(content: "10.000đ"),
        ExcelCell.empty(),
      ]),
    ]);
    final excelRow2 = ExcelRow(listCell: [
      ExcelCell(content: "Row 2", align: TextAlign.start),
      ExcelCell(content: "10%"),
      ExcelCell.empty(),
      ExcelCell(content: "10.000đ"),
      ExcelCell.empty(),
    ]);

    data = ExcelData(
        listRow: [excelRow1, excelRow2],
        initWidth: [80, null, null, null, null]);
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
                      "Column 1",
                      alignment: Alignment.centerLeft,
                    ),
                    HeaderWidget("Column 2"),
                    HeaderWidget("Column 3"),
                    HeaderWidget("Column 4"),
                    HeaderWidget(
                      "Column 5",
                      alignment: Alignment.centerRight,
                    )
                  ],
                  minColumnsWidth: const [80, 80, 80, 80, 80],
                  padding: const EdgeInsets.all(16),
                  lockedDivider: (context, width) => Container(
                    color: Colors.amber,
                    height: 0.5,
                    width: width,
                  ),
                  scrollableDivider: (context, width) => Container(
                    color: Colors.green,
                    height: 0.5,
                    width: width,
                  ),
                  onRightEffect: (context, atRight) => Visibility(
                    visible: !atRight,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.red, Colors.transparent],
                        )),
                        width: 10,
                      ),
                    ),
                  ),
                  onLeftEffect: (context, atLeft) => Visibility(
                    visible: !atLeft,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0x00FFFFFF),
                            Colors.black,
                          ],
                        )),
                        width: 20,
                      ),
                    ),
                  ),
                  emptyCellBuilder: (context) => const Divider(),
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
      child: Align(
        alignment: alignment,
        child: Text(
          title,
        ),
      ),
    );
  }
}
