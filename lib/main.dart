import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:liga_shin_test/features/contact_page/contact_page.dart';
import 'package:liga_shin_test/features/promo_page/promo_page.dart';
import 'package:liga_shin_test/features/start_page/start_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/repository/auto_shinliga_repository.dart';
import 'data/repository/remote_repository/remote_repository.dart';
import 'data/repository/repository.dart';
import 'data/repository/storage_repository/storage_repository.dart';
import 'data/storage/pref/pref.dart';
import 'data/storage/storage.dart';
import 'features/model/data_provider.dart';


void main() async {
  await initializeDateFormatting('ru', null);
  WidgetsFlutterBinding.ensureInitialized();
  final Storage storage = Pref(
      await SharedPreferences.getInstance()
  );

  final Repository rep = AutoShinLigaRepository(
    remote: RemoteRepository(
      url: 'https://auto.shinliga.ru',
      carwashingEndPoint: '/carwashing.json',
      shimontEndPoint: '/shimont.json',
    ),
    storage:  StorageRepository(storage),
  );
  GetIt.instance.registerSingleton<Repository>(rep);
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
