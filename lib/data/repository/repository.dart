import '../../features/model/data.dart';

abstract interface class Repository {
  Future<void> saveAll(List<Data> data, DataType type);

  Future<List<Data>> getAll(DataType type);
}
