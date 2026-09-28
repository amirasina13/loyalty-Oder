import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../data.dart';

// Calling API function for History Transaction (FOR TRANSACTION HISTORY)
class RemoteHistoryRepository extends HistoryRepository {
  // Get Point history list
  @override
  // ignore: avoid_renaming_method_parameters
  Future<dynamic> listPointHistory(String token, int offset) async {
    var param = <String, dynamic>{
      'offset': offset.toString(),
      'token': token,
      'access': 'mobile',
    };

    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.pointHistoryList, param);

    try {
      var response = await http.get(route, headers: header);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          if (!jsonResponse['status']) {
            throw InvalidStatusException(message: jsonResponse['message']);
          }
        } else {
          return jsonResponse;
        }

        return History.fromEntity(HistoryModel.fromJson(jsonResponse['data']));
      } else {
        throw HttpRequestException();
      }
    } catch (e) {
      if (e is InvalidStatusException) {
        rethrow;
      } else if (e is InvalidSessionException) {
        rethrow;
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later.');
      } else {
        rethrow;
      }
    }
  }

  // Get Credit history list
  @override
  // ignore: avoid_renaming_method_parameters
  Future<dynamic> listCreditHistory(String token, int offset) async {
    var param = <String, dynamic>{
      'offset': offset.toString(),
      'token': token,
      'access': 'mobile',
    };

    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(
      ServerAddresses.creditHistoryList,
      param,
    );

    try {
      var response = await http.get(route, headers: header);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          if (!jsonResponse['status']) {
            throw InvalidStatusException(message: jsonResponse['message']);
          }
        } else {
          return jsonResponse;
        }

        return CreditHistory.fromEntity(
          CreditHistoryModel.fromJson(jsonResponse['data']),
        );
      } else {
        throw HttpRequestException();
      }
    } catch (e) {
      if (e is InvalidStatusException) {
        rethrow;
      } else if (e is InvalidSessionException) {
        rethrow;
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later.');
      } else {
        rethrow;
      }
    }
  }
}
