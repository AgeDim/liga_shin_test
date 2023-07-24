import '../../features/model/shimont.dart';

enum  Type {
  wash, tire
}


abstract interface class Repository{

  /// Сохраняет все данные (не важно куда и как)
  Future<void> saveAll(List<Data> data,Type type);


  /// Забирает все данные (не важно как и откуда)
  Future<List<Data>> getAll(Type type);

}