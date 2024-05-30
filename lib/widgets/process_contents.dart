import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessContents extends StatelessWidget {
  const ProcessContents(
      {super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(
          title,
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          description,
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
