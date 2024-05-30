import 'package:com.design.studiovie/widgets/responsive.dart';
import 'package:com.design.studiovie/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:com.design.studiovie/widgets/process_card.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ProcessTimeline extends StatelessWidget {
  ProcessTimeline(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.child});
  bool isFirst = false;
  bool isLast = false;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveLayout.isPhone(context) ? 174 : 230,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: const LineStyle(color: Colors.deepPurple),
        indicatorStyle: IndicatorStyle(
          color: Colors.deepPurple,
          width: 25,
          iconStyle: IconStyle(
            iconData: Icons.done,
            color: Colors.white,
          ),
        ),
        endChild: ProcessCards(child: child),
      ),
    );
  }
}
