import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../data.dart';

// Calling API function for Security pin (FOR SECURITY PIN)
class RemoteSecurityRepository extends SecurityRepository {
  // Check security pin if already set or not
  @override
  Future<dynamic> checkSecurityPin({required String token}) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.checkSecurityPin, param);

    try {
      var response = await http.get(route, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          if (!jsonResponse['status']) {
            throw jsonResponse['message'];
          }
        } else {
          return jsonResponse;
        }

        return jsonResponse['data']['isSet'];
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

  // Send mobile no to API to get the otp code
  @override
  Future<dynamic> startSecurityPin({required String token}) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.startSecurityPin);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200 ||
          (jsonResponse['isMaintenance'] == false && !jsonResponse['status'])) {
        throw jsonResponse['message'];
      }
      return jsonResponse;
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

  // Verify otp code receive
  @override
  Future<dynamic> verifySecurityOtp({
    required String token,
    required String otp,
    required String otpToken,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.verifySecurityOtp);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'otp_token': otpToken,
      'otp': otp,
    });

    try {
      var response = await http.post(route, headers: header, body: data);
      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200 ||
          (jsonResponse['isMaintenance'] == false && !jsonResponse['status'])) {
        throw jsonResponse['message'];
      }
      return jsonResponse;
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

  // create security pin
  @override
  Future<dynamic> createSecurityPin({
    required String token,
    required String otpToken,
    required String otp,
    required String pin,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.createSecurityPin);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'otp_token': otpToken,
      'otp': otp,
      'pin': pin,
    });

    try {
      var response = await http.post(route, headers: header, body: data);
      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200 ||
          (jsonResponse['isMaintenance'] == false && !jsonResponse['status'])) {
        throw jsonResponse['message'];
      }
      // return jsonResponse['status'];
      return jsonResponse;
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

  // verify security pin
  @override
  Future<dynamic> verifySecurityPin({
    required String token,
    required String pin,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.verifySecurityPin);
    var data = json.encode(<String, String?>{
      'pin': pin,
      'token': token,
      'access': 'mobile',
    });

    try {
      var response = await http.post(route, headers: header, body: data);
      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200 ||
          (jsonResponse['isMaintenance'] == false && !jsonResponse['status'])) {
        throw jsonResponse['message'];
      }
      // return jsonResponse['status'];
      return jsonResponse;
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
