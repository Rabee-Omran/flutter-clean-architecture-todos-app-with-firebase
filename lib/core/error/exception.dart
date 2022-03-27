class ServerException implements Exception {}

class CacheException implements Exception {}

class OfflineException implements Exception {}

class InvalidDataException implements Exception {}

class CanceledByUserException implements Exception {}

class NotFoundException implements Exception {}

class InvalidDateException implements Exception {}

class FirebaseDataException implements Exception {
  final String message;

  FirebaseDataException(this.message);
}
