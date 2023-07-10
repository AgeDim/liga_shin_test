import 'package:flutter/material.dart';

import 'features/main_page/main_page.dart';
import 'features/map_page/map_page.dart';

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
      locale: const Locale('ru', 'RU'),
      debugShowCheckedModeBanner: false,
      initialRoute: MainPage.routeName,
      routes: {
        MapPage.routeName: (context) => const MapPage(),
        MainPage.routeName: (context) => const MainPage(),
      },
    );
  }
}

