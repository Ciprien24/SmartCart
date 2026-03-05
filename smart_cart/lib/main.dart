import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_cart/features/carts/carts_screen.dart';

void main() {
  runApp(const SmartCartApp());
}

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({super.key});
  static const Color _primary = Color(0xFFF3F5F8);

  @override
  Widget build(BuildContext context) {
    final montserratFamily = GoogleFonts.montserrat().fontFamily;
    final textTheme = GoogleFonts.montserratTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );
    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0F15),
      fontFamily: montserratFamily,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8A93A3),
        brightness: Brightness.dark,
      ),
      dividerColor: const Color(0xFF252B36),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1A202B),
        contentTextStyle: GoogleFonts.montserrat(
          color: const Color(0xFFF3F5F8),
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: _primary,
        textTheme: CupertinoTextThemeData(
          textStyle: GoogleFonts.montserrat(color: _primary),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: darkTheme,
      darkTheme: darkTheme,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const CartsScreen(),
    );
  }
}
