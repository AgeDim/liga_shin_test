import 'dart:convert';
import 'package:liga_shin_test/data/repository/repository.dart';
import 'package:http/http.dart' as http;

import '../../../features/model/shimont.dart';


class RemoteRepository implements Repository {

  String url;
  String carwashingEndPoint;
  String shimontEndPoint;

  RemoteRepository({
    required this.url,
    required this.carwashingEndPoint,
    required this.shimontEndPoint,
  });


  Future<dynamic> _get({required String endPoint}) async{

    final data = await http.get(Uri.parse('$url$endPoint'));

    return jsonDecode(data.body);

  }


  @override
  Future<List<Data>> getAll(Type type) async{
    switch (type) {
      case Type.wash : {
        return await _getCarwashing();
      }
      case Type.tire : {
        return await _getShimont();
      }
    }
  }

  Future<List<Data>> _getShimont() async {

    final json = await _get(endPoint: shimontEndPoint);

    return List.of(json).map((data) => Data.fromJson(data)).toList();
  }

  Future<List<Data>> _getCarwashing() async {

    final json = await _get(endPoint: carwashingEndPoint);

    return List.of(json).map((data) => Data.fromJson(data)).toList();

  }


  @override
  Future<void> saveAll(List<Data> data ,Type type) async {
    throw UnimplementedError('Метод не используется');
  }



}