import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/splash_screen.dart';

void main() => runApp(const EvoMedApp());

class EvoMedApp extends StatelessWidget {
  const EvoMedApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'EVO MED',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen(),
      );
}
