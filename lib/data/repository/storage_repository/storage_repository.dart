import 'package:liga_shin_test/data/repository/repository.dart';
import 'package:liga_shin_test/data/storage/storage.dart';
import 'package:liga_shin_test/features/model/shimont.dart';

class StorageRepository implements Repository {
  final Storage _storage;

  StorageRepository(this._storage);

  @override
  Future<List<Data>> getAll(Type type) async {
    final data = await _storage.getAll(key: type.name);

    return List.of(data).map((element) => Data.fromJson(element)).toList();
  }

  @override
  Future<void> saveAll(List<Data> data, Type type) async {
    await _storage.replaceAll(
        key: type.name,
        data: List.of(data).map((element) => element.toJson()).toList());
  }
}
