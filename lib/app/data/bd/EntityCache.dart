import 'package:apnapp/app/common/event_manager.dart';
import 'package:apnapp/app/common/logger.dart';
import 'package:apnapp/app/domain/model/_models.dart';

enum EntityCacheable {Usuario}

class EntityCacheInfo {
  EntityCacheInfo(this._entity);

  final EntityCacheable _entity;
  DateTime _lastAccess = null;
  DateTime _lastCached = null; //ultima instante datos fueron cacheados

  List<ModelDb> _cache = List();

  DateTime get lastAccess => _lastAccess;

  DateTime get lastCache => _lastAccess;

  String get entityName => _entity.toString();

  void AddItems(List<ModelDb> items) {
    items.forEach((item) {
      _cache.removeWhere((row) => row.pk == item.pk);
      _cache.add(item);
    });
    _lastCached = DateTime.now();
  }

  void AddItem(ModelDb item) {
    _cache.removeWhere((row) => row.pk == item.pk);
    _cache.add(item);

    _lastCached = DateTime.now();
  }

  bool ContainId(String id) {
    return _cache.firstWhere((element) => element.pk == id) != null;
  }

  ModelDb GetById(String id) {
    return _cache.firstWhere((element) => element.pk == id);
  }

  List<ModelDb> GetAll() {
    _lastAccess = DateTime.now();
    return _cache.toList();
  }

  int CountItemsCached() {
    return _cache.length;
  }

  Duration GetTimeLaspsedLastAccess() {
    if (_lastAccess == null) return Duration(days: 1);

    return DateTime.now().difference(_lastAccess);
  }

  Duration GetTimeLaspsedLastCached() {
    if (_lastCached == null) return Duration(days: 1);

    return DateTime.now().difference(_lastCached);
  }
}

class EntityCache {
  Stream<AppEvent> _stream;

  EntityCache._() {
    //_stream = locator<EventManager>().subscribeToChannel(EventChannel.EjercicioInApp);

    _stream.listen((event) {
      logger.i('EntityCache. Cache clear. Campaña changed');
      _cache.clear();
    });
  }

  factory EntityCache.create() {

    return EntityCache._();
  }

  Map<EntityCacheable, EntityCacheInfo> _cache = Map();

  void AddItems(EntityCacheable entityType, List<ModelDb> items) {
    if (!_cache.containsKey(entityType)) {
      _cache.putIfAbsent(entityType, () => EntityCacheInfo(entityType));
    }
    _cache[entityType].AddItems(items);
  }

  void AddItem(EntityCacheable entityType, ModelDb item) {
    if (!_cache.containsKey(entityType)) {
      _cache.putIfAbsent(entityType, () => EntityCacheInfo(entityType));
    }
    _cache[entityType].AddItem(item);
  }

  bool ContainItemId(EntityCacheable entity, String id) {
    if (!_cache.containsKey(entity)) return false;

    return _cache[entity].ContainId(id);
  }

  bool ContainEntity(EntityCacheable entity) {
    return _cache.containsKey(entity);
  }

  ModelDb GetById(EntityCacheable entity, String id) {
    if (!_cache.containsKey(entity)) return null;

    return _cache[entity].GetById(id);
  }

  List<ModelDb> GetAll(EntityCacheable entity) {
    if (!_cache.containsKey(entity)) return List();

    return _cache[entity].GetAll();
  }

  EntityCacheInfo GetCache(EntityCacheable entity) {
    return _cache[entity];
  }

  Duration TimeLaspsedLastAccess(EntityCacheable entity) {
    if (!_cache.containsKey(entity)) return Duration(days: 1000);

    return _cache[entity].GetTimeLaspsedLastAccess();
  }

  Duration TimeLaspsedLastCached(EntityCacheable entity) {
    if (!_cache.containsKey(entity)) return Duration(days: 1000);

    if (_cache[entity].CountItemsCached() == 0) return Duration(days: 1000);

    return _cache[entity].GetTimeLaspsedLastCached();
  }

  void ClearByEntity(EntityCacheable entity) {
    _cache.remove(entity);
  }

  void Clear() {
    _cache.clear();
    logger.i('EntityCache clear');
  }

  bool MaxtimeCacheElapsed(EntityCacheable entity, Duration maxinterval) {
    return entityCache.TimeLaspsedLastCached(entity).inMinutes > maxinterval.inMinutes;
  }

  bool MaxtimeAccessElapsed(EntityCacheable entity, Duration maxinterval) {
    if (entityCache.TimeLaspsedLastAccess(entity).inMinutes > maxinterval.inMinutes) return true;
    return false;
  }
}

EntityCache entityCache = EntityCache.create();
