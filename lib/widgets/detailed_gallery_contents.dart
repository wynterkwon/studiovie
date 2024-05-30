import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailedGalleryContents extends StatelessWidget {
  final String name;
  final String value;
  const DetailedGalleryContents(
      {super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text(
            name,
            style: GoogleFonts.acme(
              textStyle: const TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: Text(
            value,
            style: GoogleFonts.acme(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DetailedGalleryRoleContents extends StatelessWidget {
  final String name;
  final List<String> roles;
  const DetailedGalleryRoleContents({
    super.key,
    required this.name,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text(
            name,
            style: GoogleFonts.acme(
              textStyle: const TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: SizedBox(
              height: 25,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) => Text(
                      roles[index],
                      style: GoogleFonts.acme(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )),
                separatorBuilder: (context, index) {
                  return const Text(
                    ' | ',
                    style: TextStyle(color: Colors.white),
                  );
                },
                itemCount: roles.length,
              ),
            )),
      ],
    );
  }
}
