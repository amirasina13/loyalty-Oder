import 'dart:convert';

import '../../config/config.dart';

enum RequestType { post, get, put, delete }

class HttpClient {
  Map<String, String> createHeader({required RequestType type}) {
    switch (type) {
      case RequestType.post:
        {
          var header = <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }..addAll(_getBasicAuthHeader());

          return header;
        }
      case RequestType.get:
        return _getBasicAuthHeader();
      case RequestType.put:
        return _getBasicAuthHeader();
      case RequestType.delete:
        return _getBasicAuthHeader();
    }
  }

  Map<String, String> _getBasicAuthHeader() {
    return <String, String>{
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${AppConfig.apiUsername}:${_generatePassword()}'))}',
    };
  }

  Uri createUri(String route, [Map<String, dynamic> param = const {}]) {
    var baseUri = Uri.parse(AppConfig.apiUrl + route);

    // Only add query parameters if the map is not empty
    if (param.isNotEmpty) {
      var urlWithParams = baseUri.replace(queryParameters: param);
      return urlWithParams;
    }

    return baseUri;
  }

  String _generatePassword() {
    return AppConfig.apiPassword;
  }
}
