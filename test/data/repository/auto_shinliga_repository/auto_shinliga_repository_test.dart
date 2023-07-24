import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liga_shin_test/data/repository/auto_shinliga_repository.dart';
import 'package:liga_shin_test/data/repository/remote_repository/remote_repository.dart';
import 'package:liga_shin_test/data/repository/repository.dart';
import 'package:liga_shin_test/data/repository/storage_repository/storage_repository.dart';
import 'package:liga_shin_test/data/storage/pref/pref.dart';
import 'package:liga_shin_test/data/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

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

  test('Test get shimount', () async {

    final data = await rep.getAll(Type.tire);

  });

  test('Test get carwashing', () async {

    final data = await rep.getAll(Type.wash);

  });

  test('Test get carwashing from storage', () async {

    final data = await  storage.getAll(key: Type.wash.name);

  });
}