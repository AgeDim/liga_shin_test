import 'package:liga_shin_test/data/repository/repository.dart';
import 'package:liga_shin_test/features/services/logger.dart';

import '../../features/model/data.dart';

class AutoShinLigaRepository  implements Repository {
  Repository remote;
  Repository storage;

  AutoShinLigaRepository({required this.remote, required this.storage});

  @override
  Future<List<Data>> getAll(DataType type) async {
    try {
      final data = await remote.getAll(type);
      await storage.saveAll(data, type);
      return data;
    } catch (exception) {
      CustomLogger.info('No Internet');
      CustomLogger.info(exception.toString());
      return storage.getAll(type);
    }
  }

  @override
  Future<void> saveAll(List<Data> data, DataType type) async {
    await storage.saveAll(data, type);
  }
}
