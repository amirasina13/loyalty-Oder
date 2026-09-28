//Exception that is thrown when http request call response is not 200

class HttpRequestException implements Exception {}

class RemoteServerException implements Exception {}

class LocalDatabaseException implements Exception {}

class InvalidSessionException implements Exception {
  final String message;

  InvalidSessionException({required this.message});
}

class InvalidStatusException implements Exception {
  final String message;

  InvalidStatusException({required this.message});
}

class InvalidNetworkException implements Exception {
  final String message;

  InvalidNetworkException({required this.message});
}

class MaintenanceException implements Exception {
  final bool isMaintenance;
  final String message;

  MaintenanceException({required this.isMaintenance, required this.message});
}

//Exception that is thrown when Entity to Model conversion is performed
class EntityModelMapperException implements Exception {
  final String? message;

  EntityModelMapperException({required this.message});
}

class EmptyDataException implements Exception {
  final String message;

  EmptyDataException({required this.message});

  @override
  String toString() => message;
}
