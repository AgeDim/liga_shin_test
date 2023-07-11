import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/contact_page/contact_page.dart';
import 'package:liga_shin_test/features/promo_page/promo_page.dart';
import 'package:liga_shin_test/features/start_page/start_page.dart';

import 'features/main_page/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: StartPage.routeName,
      routes: {
        MainPage.routeName: (context) => const MainPage(),
        StartPage.routeName: (context) => const StartPage(),
        PromoPage.routeName: (context) => const PromoPage(),
        ContactPage.routeName: (context) => const ContactPage(),
      },
    );
  }
}
