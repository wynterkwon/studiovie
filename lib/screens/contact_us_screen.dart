import 'package:com.design.studiovie/constants/contents.dart';
import 'package:com.design.studiovie/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:com.design.studiovie/widgets/admin_scaffold.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                makeContactItem(context, Icons.email, contactEmail),
                const SizedBox(
                  height: 10,
                ),
                makeContactItem(context, Icons.smartphone, contactNumber),
                const SizedBox(
                  height: 10,
                ),
                makeContactItem(context, Icons.star, instaAddress),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            Center(
              child: Container(
                color: Colors.white,
                child: QrImageView(
                  data: instaUrl,
                  // data: webUrl,
                  version: QrVersions.auto,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.circle,
                    color: Colors.grey,
                  ),
                  embeddedImage: const AssetImage('assets/icons/appstore.png'),
                  size: 200.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row makeContactItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Icon(
            icon,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Flexible(
          flex: 3,
          child: Text(
            text,
            style: GoogleFonts.acme(
              color: Colors.white,
              fontSize: ResponsiveLayout.isPhone(context) ? 20 : 30,
            ),
          ),
        ),
      ],
    );
  }
}
