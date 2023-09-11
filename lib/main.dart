import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:tomatoes/login_sinup/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tomatoes/getstart/getstart.dart';

//global object for accessing device screen size
//study about this later
late Size thisSize;

void main() async {
  //Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    thisSize = MediaQuery.of(context).size;
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF83015)),
        useMaterial3: true,
        textTheme: TextTheme(
          displayMedium: GoogleFonts.dancingScript(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.w900,
          ),
          titleSmall: GoogleFonts.sourceSerif4(
            fontSize: 15,
            color: Colors.black,
          ),
          titleMedium: GoogleFonts.sourceSerif4(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.sourceSerif4(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineMedium: GoogleFonts.sourceSerif4(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineSmall: GoogleFonts.sourceSerif4(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.sourceSerif4(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 1.5),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const getStart(),
    );
  }
}
