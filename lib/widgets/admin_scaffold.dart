import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget body;
  final List<Widget> actions;
  final Widget? leading;

  MyScaffold(
      {Key? key, required this.body, this.actions = const [], this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: actions,
        leading: leading,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Color.fromARGB(255, 36, 1, 43),
                  Colors.purple.shade100,
                  // Color(0xff1f2123),
                  Color.fromARGB(255, 36, 1, 43),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: body,
          ),
        ],
      ),
    );
  }
}
