import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;

  const LoadingIndicator({
    super.key,
    this.color,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        color: color,
      );
    }
    return CircularProgressIndicator(
      color: color,
      strokeWidth: strokeWidth ?? 4.0,
    );
  }
}
