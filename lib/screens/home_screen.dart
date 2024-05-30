import 'package:com.design.studiovie/widgets/base_scaffold.dart';
import 'package:com.design.studiovie/widgets/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:com.design.studiovie/constants/contents.dart';
import 'package:com.design.studiovie/viewmodels/admin_vm.dart';
import 'package:com.design.studiovie/viewmodels/gallery_vm.dart';
import 'package:com.design.studiovie/widgets/trusted_by_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      GlobalKey<ScaffoldState>();

  bool isHovering = false;

  late Future<List<String>> _getPartners;

  Future<List<String>> getPartners() async {
    List<String> partnersImageUrl = [];
    for (var i = 0; i < partners.length; i++) {
      final url = await context
          .read<GalleryViewModel>()
          .getPartnersImageUrl(partners[i].toLowerCase());
      partnersImageUrl.add(url);
    }
    return partnersImageUrl;
  }

  TextStyle optionStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    context.read<GalleryViewModel>().fetchGalleryData();
    _getPartners = getPartners();
  }

  @override
  Widget build(BuildContext context) {
    return
        // ResponsiveScaffold();

        BaseScaffold(
      key: _drawerscaffoldkey,
      leading: ResponsiveLayout.isPhone(context)
          ? makePopupMenuButton(context)
          : null,
      drawer: ResponsiveLayout.isPhone(context)
          ? SizedBox.shrink()
          : makeDrawer(optionStyle),
      body: SafeArea(
        child: ResponsiveLayout(
          phone: SingleChildScrollView(
            child: Column(children: [
              Expanded(
                flex: 5,
                child: mainText(context),
              ),
              Expanded(
                flex: 1,
                child: trustedCarousel(context),
              ),
            ]),
          ),
          tablet: Column(
            children: [
              Expanded(
                flex: 7,
                child: mainText(context),
              ),
              Expanded(
                flex: 1,
                child: trustedCarousel(context),
              ),
            ],
          ),
          desktop: Column(
            children: [
              Expanded(
                flex: 5,
                child: mainText(context),
              ),
              Expanded(
                flex: 1,
                child: trustedCarousel(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainText(context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Studio Vie',
              style: GoogleFonts.acme(
                textStyle: TextStyle(
                  fontSize: ResponsiveLayout.isPhone(context)
                      ? 40
                      : ResponsiveLayout.isDesktop(context)
                          ? 80
                          : 100,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Text(
          'all about LIFE DESIGN',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveLayout.isPhone(context)
                ? 20
                : ResponsiveLayout.isDesktop(context)
                    ? 30
                    : 40,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  deviceWidth < WidthSE
                      ? mainDesp4SE
                      : ResponsiveLayout.isDesktop(context)
                          ? mainDesp4Web
                          : mainDescription,
                  textAlign: TextAlign.center,
                  maxLines: ResponsiveLayout.isDesktop(context) ? 5 : 8,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.nanumBrushScript(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveLayout.isPhone(context)
                          ? 20
                          : ResponsiveLayout.isTablet(context)
                              ? 38
                              : 30,
                      height: 1.5,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ResponsiveLayout.isTablet(context) ? 100 : 30,
        ),
        if (!kIsWeb)
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/gallery'),
            child: Text(
              '→ See the projects',
              style: GoogleFonts.acme(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveLayout.isPhone(context) ? 25 : 60,
                ),
              ),
            ),
            splashColor: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
        if (kIsWeb)
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: isHovering ? 300 : 250,
            height: isHovering ? 80 : 60,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/gallery');
              },
              child: Text(
                '→ See the projects',
                style: GoogleFonts.acme(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
              onHover: (value) {
                setState(() {
                  // context.read<GalleryViewModel>();
                  isHovering = value;
                });
              },
            ),
          ),
      ],
    );
  }

  Widget trustedCarousel(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Container(height: 1, color: Colors.white)),
            Text(
              '  Trusted by Many  ',
              style: GoogleFonts.acme(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Flexible(child: Container(height: 1, color: Colors.white)),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
            child: TrustedByCarousel(
          getPartners: _getPartners,
        )),
      ],
    );
  }

  PopupMenuButton<String> makePopupMenuButton(BuildContext context) {
    print('phone appbar : ${MediaQuery.of(context).size.width}');
    return PopupMenuButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onSelected: (value) {
          context.read<AdminViewModel>().freeGalleryResources();
          Navigator.pushNamed(context, value.toString());
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(
              value: '/gallery',
              child: Text(
                'Gallery',
              ),
            ),
            const PopupMenuItem(
              value: '/process',
              child: Text(
                'Process',
              ),
            ),
            const PopupMenuItem(
              value: '/contact',
              child: Text(
                'Contact Us',
              ),
            ),
            const PopupMenuItem(
              value: '/admin',
              child: Text(
                '🔐 Admin',
              ),
            ),
          ];
        });
  }

  Widget makeDrawer(TextStyle optionStyle) {
    return Drawer(
      backgroundColor: Colors.purple.shade50,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                'Studio Vie',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
            ),
          ),
          ListTile(
            title: Text(
              'Gallery',
              style: optionStyle,
            ),
            // selected: _selectedIndex == 1,
            onTap: () {
              Navigator.pushNamed(context, '/gallery');
            },
            // selected: true,
          ),
          ListTile(
            title: Text('Process', style: optionStyle),
            // selected: _selectedIndex == 2,
            onTap: () {
              Navigator.pushNamed(context, '/process');
            },
          ),
          ListTile(
            title: Text('Contact Us', style: optionStyle),
            // selected: _selectedIndex == 2,
            onTap: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
          ListTile(
            title: Text('🔐 Admin', style: optionStyle),
            // selected: _selectedIndex == 2,
            onTap: () {
              Navigator.pushNamed(context, '/admin');
            },
          ),
        ],
      ),
    );
  }
}
