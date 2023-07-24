import 'package:flutter_test/flutter_test.dart';
import 'package:liga_shin_test/data/repository/remote_repository/remote_repository.dart';
import 'package:liga_shin_test/data/repository/repository.dart';

void main(){

  final Repository rep = RemoteRepository(
     url: 'https://auto.shinliga.ru',
     carwashingEndPoint: '/carwashing.json',
     shimontEndPoint: '/shimont.json',
  );

  test('Test get shimount', () async {

    final data = await rep.getAll(Type.tire);

  });

  test('Test get carwashing', () async {

    final data = await rep.getAll(Type.wash);

  });
}