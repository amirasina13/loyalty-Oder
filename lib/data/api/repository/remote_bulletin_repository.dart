import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../data.dart';

// Calling API function for bulletin (IF NEWS PAGE)
class RemoteBulletinRepository extends BulletinRepository {
  // Get Bulletin list
  @override
  Future<dynamic> listBulletin(String token, type) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(
      ServerAddresses.bulletinList + type,
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

        List<dynamic> data = jsonResponse['data'] ?? []; //// added ['vouchers]

        List<Bulletin> bulletins = [];
        for (int i = 0; i < data.length; i++) {
          bulletins.add(Bulletin.fromEntity(BulletinModel.fromJson(data[i])));
        }
        return bulletins;
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

  // Get Bulletin details
  @override
  Future<dynamic> getDetails(String token, String bulletinId) async {
    var param = <String, dynamic>{
      'id': bulletinId.toString(),
      'token': token,
      'access': 'mobile',
    };
    var route = HttpClient().createUri(ServerAddresses.bulletinDetail, param);
    try {
      var response = await http.get(
        route,
        headers: HttpClient().createHeader(type: RequestType.get),
      );

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

        var details = BulletinDetails.fromEntity(
          BulletinDetailsModel.fromJson(jsonResponse['data']),
        );

        return details;
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
