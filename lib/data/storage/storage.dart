/// ### Interface for defining the entity associated
/// ### with adding data to the internal data store
///
/// * [Map<String, dynamic>] is used for data exchange
abstract interface class Storage {
  /// ## Define method for replace data.
  ///
  /// * [key] - storage key, where find element.
  /// * [data] - data to add.
  Future<void> add({required String key, required Map<String, dynamic> data});

  /// ## Define method for get data.
  ///
  /// * [key] - storage key, where find element.
  /// * [value] - unique value by which we will search for the element.
  /// * [by] -  id value to compare with [value].
  Future<Map<String, dynamic>?> get(
      {required String key, required String value, required String by});

  /// ## Define method for replace data.
  ///
  /// * [key] - storage key, where find element.
  /// * [value] - unique value by which we will search for the element.
  /// * [by] - id value to compare with [value].
  /// * [replaceData] - data for replace.
  Future<void> replace(
      {required String key,
        required String value,
        required String by,
        required Map<String, dynamic> replaceData});

  /// ## Define method for remove data.
  ///
  /// * [key] - storage key, where find element.
  /// * [value] - unique value by which we will search for the element.
  /// * [by] - id value to compare with [value].
  Future<void> remove(
      {required String key, required String value, required String by});

  /// ## Define method for get all data.
  ///
  /// * [key] - storage key, where find elements.
  Future<List<dynamic>> getAll({required String key});

  /// ## Define method for replace all data.
  ///
  /// * [key] - storage key, where replace elements.
  /// * [data] - replacement data
  Future<void> replaceAll(
      {required String key, required List<Map<String, dynamic>> data});
}