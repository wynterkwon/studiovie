import 'package:flutter/material.dart';

class ProcessCards extends StatelessWidget {
  const ProcessCards({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: Colors.purple.shade100,
          border: Border.all(color: Colors.white)),
      child: child,
    );
  }
}
