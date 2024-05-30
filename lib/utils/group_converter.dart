import 'package:flutter/material.dart';
import 'package:com.design.studiovie/constants/constants.dart';
import 'package:com.design.studiovie/constants/enums.dart';
import 'package:com.design.studiovie/utils/studio_vie_app_icon_icons.dart';

class GroupConverter {
  static IconData toIcon({required ProjectsKinds group}) {
    switch (group) {
      case ProjectsKinds.office:
        return Icons.home_work;
      case ProjectsKinds.hospital:
        return StudioVieAppIcon.hospital;
      case ProjectsKinds.retail:
        return Icons.storefront;
      default:
        return Icons.bookmark;
    }
  }
 

  static List<Color> toGradient({required ProjectsKinds group}) {
    switch (group) {
      case ProjectsKinds.office:
        return officeGradientList;
      case ProjectsKinds.hospital:
        return hospitalGradientList;
      case ProjectsKinds.retail:
        return retailGradientList;
      default:
        return othersGradientList;
    }
  }
}
