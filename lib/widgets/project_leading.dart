import 'package:com.design.studiovie/constants/enums.dart';
import 'package:com.design.studiovie/widgets/responsive.dart';
import 'package:flutter/material.dart';
// import 'package:studiovie/constants/enums.dart';

class ProjectLeading extends StatelessWidget {
  final IconData icon;
  final List<Color> gradient;
  final ProjectsKinds group;
  const ProjectLeading({
    super.key,
    required this.icon,
    required this.gradient,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Colors.purple.shade200,
            // gradient: RadialGradient(
            //   colors: [...gradient],
            //   center: const Alignment(1, 1),
            //   focal: const Alignment(0.3, -0.1),
            //   focalRadius: 0.8,
            // ),
            color: Colors.grey.withOpacity(0.4)),
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            color: Colors.white,
            size: ResponsiveLayout.isPhone(context) ? 20 : 30,
          ),
          tooltip: group.toString().split('.')[1].toUpperCase(),
        ));
  }
}
