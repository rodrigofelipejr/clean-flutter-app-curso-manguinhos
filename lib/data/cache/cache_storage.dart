//NOTE - candidate to interface segregation principal
abstract class CacheStorage {
  Future<dynamic> fetch(String key);
  Future<void> delete(String key);
}
