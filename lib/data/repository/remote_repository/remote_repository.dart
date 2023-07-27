import 'dart:convert';
import 'package:liga_shin_test/data/repository/repository.dart';
import 'package:http/http.dart' as http;

import '../../../features/model/data.dart';

class RemoteRepository implements Repository {
  String url;
  String carwashingEndPoint;
  String shimontEndPoint;

  RemoteRepository({
    required this.url,
    required this.carwashingEndPoint,
    required this.shimontEndPoint,
  });

  Future<dynamic> _get({required String endPoint}) async {
    final data = await http.get(Uri.parse('$url$endPoint'));

    return jsonDecode(data.body);
  }

  @override
  Future<List<Data>> getAll(DataType type) async {
    switch (type) {
      case DataType.carWashing:
        {
          return await _getCarwashing();
        }
      case DataType.shimont:
        {
          return await _getShimont();
        }
      case DataType.lastUpdate:
        {
          return [];
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
  Future<void> saveAll(List<Data> data, DataType type) async {
    throw UnimplementedError('Метод не используется');
  }
}
