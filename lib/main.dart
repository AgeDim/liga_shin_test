import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/contact_page/contact_page.dart';
import 'package:liga_shin_test/features/promo_page/promo_page.dart';
import 'package:liga_shin_test/features/start_page/start_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';

import 'features/model/provider_shimont.dart';
import 'features/model/shimont.dart';

void main() async {
  await initializeDateFormatting('ru', null);
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getString('lastUpdate') == null ? true : false;
  print(isFirstRun);
  if (isFirstRun) {
    try {
      var shimont =
          await http.get(Uri.parse('https://auto.shinliga.ru/shimont.json'));
      if (shimont.statusCode == 200) {
        List<Data> shimontList = [];
        var jsonData = json.decode(shimont.body);
        for (final data in jsonData) {
          shimontList.add(Data.fromJson(data));
        }
        List<String> firstListString =
            shimontList.map((data) => jsonEncode(data.toJson())).toList();
        prefs.setStringList("shimont", firstListString);
        prefs.setString('lastUpdate', DateTime.now().toString());
      }
      var carWashing =
          await http.get(Uri.parse('https://auto.shinliga.ru/carwashing.json'));
      if (carWashing.statusCode == 200) {
        List<Data> carWashingList = [];
        var jsonData = json.decode(carWashing.body);
        for (final data in jsonData) {
          carWashingList.add(Data.fromJson(data));
        }
        List<String> secondListString =
            carWashingList.map((data) => jsonEncode(data.toJson())).toList();
        prefs.setStringList("carWashing", secondListString);
        prefs.setString('lastUpdate', DateTime.now().toString());
      }
    } catch (e) {
      print("Error updating data: $e");
    }
  }
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: StartPage.routeName,
        routes: {
          StartPage.routeName: (context) => const StartPage(),
          PromoPage.routeName: (context) => const PromoPage(),
          ContactPage.routeName: (context) => const ContactPage(),
        },
      ),
    );
  }
}
