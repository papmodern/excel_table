# excel_table

A table widget scrollable when not enough width space, can set locked column like microsoft excel

## Features 

* Lock cloums 
* Scrollable rest
* Effect when scroll
* Row can expand sub row

## Supported platforms

* Flutter Android
* Flutter iOS
## Installation

Add `excel_table: any` to your `pubspec.yaml` dependencies. And import it:

```dart
import 'package:excel_table/excel_table.dart';
```

## How to use

Create your table data using
ExcelCell
ExcelRow
ExcelData

Simply create a `ExcelTable` widget, and pass the required params:

```dart
ExcelTable(
  data: excelData,
  headers: List<Widget> [],
  minColumnsWidth: <double>[],
)
```
See more on example project
## License

MIT
