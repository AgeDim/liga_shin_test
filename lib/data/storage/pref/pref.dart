import 'dart:convert';

import 'package:liga_shin_test/data/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref implements Storage{

  SharedPreferences pref;

  Pref(this.pref);

  @override
  Future<void> add({required String key, required Map<String, dynamic> data}) async {
    pref.setString(key, data.toString());
  }

  @override
  Future<Map<String, dynamic>?> get({required String key, required String value, required String by}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> getAll({required String key}) async {
    final  data = pref.getString(key);

    if(data != null){

      final result = jsonDecode(data);

      return  result;
    }else{
      return [];
    }

  }

  @override
  Future<void> remove({required String key, required String value, required String by}) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<void> replace({required String key, required String value, required String by, required Map<String, dynamic> replaceData}) {
    // TODO: implement replace
    throw UnimplementedError();
  }

  @override
  Future<void> replaceAll({required String key, required List<Map<String, dynamic>> data}) async {

    await pref.setString(key, jsonEncode(data));

  }







}