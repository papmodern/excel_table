import 'package:flutter/material.dart';

class MainDivider extends StatelessWidget {
  const MainDivider({
    Key? key,
    required this.color,
    required this.width,
  }) : super(key: key);

  final Color? color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? const Color.fromRGBO(0, 0, 0, 0.98),
      height: 0.5,
      width: width,
    );
  }
}
