import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../data.dart';

// Calling API function for Global (FOR MOBILE COUNRY CODE)
class RemoteGlobalRepository extends GlobalRepository {
  // Get Countries list
  @override
  Future<List<Country>> getCountries() async {
    var route = HttpClient().createUri(ServerAddresses.country);
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult.contains(ConnectivityResult.none)) {
      throw InvalidNetworkException(message: 'No internet Connection.');
    } else {
      try {
        var response = await http.get(
          route,
          headers: HttpClient().createHeader(type: RequestType.get),
        );

        if (response.statusCode == 200) {
          Map jsonResponse = json.decode(response.body);

          if (!jsonResponse['status']) {
            throw InvalidStatusException(message: jsonResponse['message']);
          }

          List<dynamic> data = jsonResponse['data'];
          List<Country> countries = [];
          for (int i = 0; i < data.length; i++) {
            countries.add(Country.fromEntity(CountryModel.fromJson(data[i])));
          }

          return countries;
        } else {
          throw HttpRequestException();
        }
      } catch (e) {
        if (e is InvalidStatusException) {
          rethrow;
        } else if (e is Exception) {
          throw Exception('Something is wrong. Please try again later.');
        } else {
          rethrow;
        }
      }
    }
  }

  // Get Global API
  @override
  Future<Map> getGlobalData() async {
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.global);

    try {
      var response = await http.get(route, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (!jsonResponse['status']) {
          throw jsonResponse['message'];
        }

        return jsonResponse;
      } else {
        throw HttpRequestException();
      }
    } catch (e) {
      if (e is InvalidStatusException) {
        throw Exception(e.message);
      } else if (e is InvalidSessionException) {
        throw Exception(e.message);
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later. $e');
      } else {
        rethrow;
      }
    }
  }
}
