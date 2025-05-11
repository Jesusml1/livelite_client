import 'package:flutter/material.dart';

class ViewersCountWidget extends StatelessWidget {
  final int count;
  const ViewersCountWidget({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.person_outline_outlined,
          color: Colors.white,
          size: 16,
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
