import 'dart:developer';
import 'package:liga_shin_test/data/repository/repository.dart';
import 'package:liga_shin_test/features/model/shimont.dart';

class AutoShinLigaRepository implements Repository{

  Repository remote;
  Repository storage;


  AutoShinLigaRepository({required this.remote, required this.storage});


  @override
  Future<List<Data>> getAll(Type type) async {

    try{

      final data = await remote.getAll(type);
      await storage.saveAll(data, type);
      return data;
    }catch(exception){
      //todo: Обработать исключение
      log(exception.toString());

      return  storage.getAll(type);
    }


  }

  @override
  Future<void> saveAll(List<Data> data, Type type) async{

    await storage.saveAll(data, type);

  }



}