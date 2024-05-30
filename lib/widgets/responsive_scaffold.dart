import 'dart:io';

import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget? phoneLeading; // Optional phone-specific leading widget
  final Widget? phoneActions; // Optional phone-specific actions

  final Widget? tabletLeading; // Optional tablet-specific leading widget
  final Widget? tabletActions; // Optional tablet-specific actions

  final Widget? desktopLeading; // Optional desktop-specific leading widget
  final Widget? desktopActions; // Optional desktop-specific actions

  final Widget body = CircularProgressIndicator();
  final Widget? phoneBody; // Optional phone-specific body
  final Widget? tabletBody; // Optional tablet-specific body
  final Widget? desktopBody;

  static double phoneLimit = 650; // Screen width breakpoint for phone
  static double tabletLimit = 1100; // Screen width breakpoint for tablet

  ResponsiveScaffold({
    super.key,
    this.phoneLeading,
    this.phoneActions,
    this.tabletLeading,
    this.tabletActions,
    this.desktopLeading,
    this.desktopActions,
    this.phoneBody,
    this.tabletBody,
    this.desktopBody,
    // this.phoneLimit = 650,
    // this.tabletLimit = 1100,
  });

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit &&
      MediaQuery.of(context).size.width >= phoneLimit;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletLimit;

  @override
  Widget build(BuildContext context) {
    // Set status bar color based on platform (adjust as needed)
    // if (DefaultPlatform.isAndroid) {
    //   SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    //   );
    // }
  
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        final scaffold = Scaffold(
          backgroundColor: Colors.transparent, // Common background for all
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Common background for all
            foregroundColor: Colors.white, // Common foreground color for all
            leading: chooseLeading(context, constraints),
            actions: chooseActions(context, constraints),
          ),
          body: chooseBody(constraints),
        );

        // Optional insets for specific breakpoints (adjust as needed)
        if (isTablet(context)) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: scaffold,
          );
        } else if (isDesktop(context)) {
          return Center(
            child: SizedBox(
              width: 800, // Adjust width for desktop layout
              child: scaffold,
            ),
          );
        }

        return scaffold;
      },
    );
  }

  Widget chooseLeading(BuildContext context, BoxConstraints constraints) {
    if (isPhone(context) && phoneLeading != null) {
      return phoneLeading!;
    } else if (isTablet(context) && tabletLeading != null) {
      return tabletLeading!;
    } else if (desktopLeading != null) {
      return desktopLeading!;
    } else {
      return const SizedBox(); // Default empty widget
    }
  }

  List<Widget> chooseActions(BuildContext context, BoxConstraints constraints) {
    if (isPhone(context) && phoneActions != null) {
      return [phoneActions!];
    } else if (isTablet(context) && tabletActions != null) {
      return [tabletActions!];
    } else if (desktopActions != null) {
      return [desktopActions!];
    } else {
      return const []; // Empty list
    }
  }

  Widget chooseBody(BoxConstraints constraints) {
    if (constraints.maxWidth < phoneLimit) {
      return phoneBody ?? body; // Use phoneBody if provided, otherwise body
    } else if (constraints.maxWidth < tabletLimit) {
      return tabletBody ?? body; // Use tabletBody if provided, otherwise body
    } else {
      return desktopBody ?? body; // Use desktopBody if provided, otherwise body
    }
  }
}
