import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:com.design.studiovie/firebase_options.dart';
import 'package:com.design.studiovie/models/data/auth_repository.dart';
import 'package:com.design.studiovie/models/data/data_source.dart';
import 'package:com.design.studiovie/models/data/gallery_data_repository.dart';
import 'package:com.design.studiovie/screens/admin_screen.dart';
import 'package:com.design.studiovie/screens/gallery_list_screen.dart';
import 'package:com.design.studiovie/screens/home_screen.dart';
import 'package:com.design.studiovie/screens/process_screen.dart';
import 'package:com.design.studiovie/viewmodels/admin_vm.dart';
import 'package:com.design.studiovie/viewmodels/auth_vm.dart';
import 'package:com.design.studiovie/viewmodels/gallery_vm.dart';
import 'package:com.design.studiovie/screens/contact_us_screen.dart';

void main() async {
  DateTime start = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  DateTime end = DateTime.now();
  print("소요 시간 : ${end.difference(start)}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>(create: (_) => FirebaseFirestore.instance),
        Provider<FirebaseStorage>(create: (_) => FirebaseStorage.instance),
        Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
        Provider<GalleryDataSource>(
            create: (context) => GalleryDataSource(
                  db: Provider.of<FirebaseFirestore>(context, listen: false),
                  storage: Provider.of<FirebaseStorage>(context, listen: false),
                  auth: Provider.of<FirebaseAuth>(context, listen: false),
                )),
        Provider<GalleryRepository>(
            create: (context) => GalleryRepository(
                  Provider.of<GalleryDataSource>(context, listen: false),
                )),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              auth: Provider.of<FirebaseAuth>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
              Provider.of<AuthRepository>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminViewModel(
              Provider.of<GalleryRepository>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => GalleryViewModel(
              Provider.of<GalleryRepository>(context, listen: false)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Studio Vie Gallery',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, onSecondary: Colors.white),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          '/gallery': (context) => const GalleryListScreen(),
          '/process': (context) => ProcessScreen(),
          '/contact': (context) => const ContactUs(),
          '/admin': (context) => AdminScreen(),
        },
      ),
    );
  }
}
