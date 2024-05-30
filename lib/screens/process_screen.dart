import 'package:flutter/material.dart';
import 'package:com.design.studiovie/constants/contents.dart';
import 'package:com.design.studiovie/widgets/process_contents.dart';
import 'package:com.design.studiovie/widgets/timeline.dart';

class ProcessScreen extends StatelessWidget {
  ProcessScreen({super.key});
  List<String> process = [
    'Planning',
    planningTitle,
    planningDescription,
    'Designing',
    designingTitle,
    designingDescription,
    'Modeling',
    modelingTitle,
    modelingDescription,
    'Construction',
    constructionTitle,
    constructionDescription
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 36, 1, 43),
                Color(0xff1f2123),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: [
                  ProcessTimeline(
                      isFirst: true,
                      isLast: false,
                      child: ProcessContents(
                          title: planningTitle,
                          description: planningDescription)),
                  ProcessTimeline(
                      isFirst: false,
                      isLast: false,
                      child: ProcessContents(
                          title: designingTitle,
                          description: designingDescription)),
                  ProcessTimeline(
                      isFirst: false,
                      isLast: false,
                      child: ProcessContents(
                          title: modelingTitle,
                          description: modelingDescription)),
                  ProcessTimeline(
                      isFirst: false,
                      isLast: true,
                      child: ProcessContents(
                          title: constructionTitle,
                          description: constructionDescription)),
                ],
              ),
            ),
          ),
        ));
  }
}
