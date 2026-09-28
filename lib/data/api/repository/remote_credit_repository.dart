import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../data.dart';

// Calling API function for credit (FOR PAYMENT AND ONLINE TOPUP CREDITS)
class RemoteCreditRepository extends CreditRepository {
  // Get credit payment qrcode info
  @override
  Future<dynamic> getCreditPayment({
    required String token,
    required String pin,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.creditPayment);
    var data = json.encode(<String, String?>{
      'pin': pin,
      'token': token,
      'access': 'mobile',
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['status']) {
            throw jsonResponse['message'];
          }
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          if (!jsonResponse['status']) {
            throw InvalidStatusException(message: jsonResponse['message']);
          }
        } else {
          return jsonResponse;
        }

        var details = CreditPayment.fromEntity(
          CreditPaymentModel.fromJson(jsonResponse['data']),
        );

        return details;
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

  // Post credit payment to get url for open payment gateaway
  @override
  Future<dynamic> onlineCreditPayment(
    String token,
    String amount,
    String pin,
  ) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.creditOnlineTopup);

    var data = json.encode(<String, dynamic>{
      'token': token,
      'access': 'mobile',
      'amount': amount,
      'pin': pin,
    });

    try {
      var response = await http.post(route, headers: header, body: data);

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

        return jsonResponse['data']['url'];
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

  // Get credit payment qrcode info
  @override
  Future<dynamic> pointConversion({
    required String token,
    required String pin,
    required String pointsConvert,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.pointConversion);
    var data = json.encode(<String, String?>{
      'pin': pin,
      'points': pointsConvert,
      'token': token,
      'access': 'mobile',
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['status']) {
            throw jsonResponse['message'];
          }
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          if (!jsonResponse['status']) {
            throw InvalidStatusException(message: jsonResponse['message']);
          }
        } else {
          return jsonResponse;
        }

        // var details = CreditPayment.fromEntity(
        //     CreditPaymentModel.fromJson(jsonResponse['data']));

        return jsonResponse;
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
