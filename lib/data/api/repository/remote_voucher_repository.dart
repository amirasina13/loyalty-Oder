import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../data.dart';

// Calling API function for Voucher (FOR VOUCHER PAGE)
class RemoteVoucherRepository extends VoucherRepository {
  @override
  Future<dynamic> listVoucherCategories(
    String filterBy,
    String filterValue,
    String token,
  ) async {
    var param = <String, dynamic>{
      'filterBy': filterBy,
      'filterValue': filterValue,
      'token': token,
      'access': 'mobile',
    };

    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.myVoucherList, param);

    // VoucherData? vouchers;

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

        // jsonResponse['data']['vouchers'] is List
        //     ? vouchers = null
        //     : vouchers = VoucherData.fromEntity(
        //         VoucherDataModel.fromJson(jsonResponse['data']));

        // var vouchers = VoucherData.fromEntity(
        //     VoucherDataModel.fromJson(jsonResponse['data']));

        // return vouchers;
        return VoucherData.fromEntity(
          VoucherDataModel.fromJson(jsonResponse['data']),
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

  // Get list past voucher (PAST)
  @override
  Future<dynamic> listPastVouchers(String token) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.voucherPast, param);

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

        List<dynamic> data =
            jsonResponse['data']['vouchers'] ?? []; //// added ['vouchers]

        List<VoucherPast> vouchersPast = [];
        for (int i = 0; i < data.length; i++) {
          vouchersPast.add(
            VoucherPast.fromEntity(VoucherPastModel.fromJson(data[i])),
          );
        }
        return vouchersPast;
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

  // Get voucher details
  @override
  Future<dynamic> getDetails(
    String token,
    String voucherId,
    String latitude,
    String longitude,
  ) async {
    var param = <String, dynamic>{
      'vId': voucherId.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'access': 'mobile',
    };
    var route = HttpClient().createUri(ServerAddresses.voucherDetails, param);
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

        var details = VoucherDetails.fromEntity(
          VoucherDetailsModel.fromJson(jsonResponse['data']),
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

  // Get past/history voucher details
  @override
  Future<dynamic> getPastVoucherDetails(String token, String voucherId) async {
    var param = <String, dynamic>{
      'id': voucherId.toString(),
      'token': token,
      'access': 'mobile',
    };
    var route = HttpClient().createUri(
      ServerAddresses.voucherPastDetail,
      param,
    );
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

        var pastDetails = VoucherPastDetails.fromEntity(
          VoucherPastDetailsModel.fromJson(jsonResponse['data']),
        );

        return pastDetails;
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

  @override
  Future<dynamic> redeemVoucher(
    String voucherId,
    String qrCode,
    String pin,
    String token,
  ) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.redeemVoucher);
    var data = json.encode(<String, String?>{
      'id': voucherId,
      'qrCode': qrCode,
      'pin': pin,
      'token': token,
      'access': 'mobile',
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
        }

        return jsonResponse;
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

  @override
  Future<dynamic> ratingVoucher(
    String id,
    int rating,
    String comment,
    String token,
  ) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.voucherReview);
    var data = json.encode(<String, dynamic>{
      'id': id,
      'rating': rating,
      'comment': comment,
      'token': token,
      'access': 'mobile',
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          // if (!jsonResponse['status']) {
          //   throw InvalidStatusException(message: jsonResponse['message']);
          // }
        }

        return jsonResponse;
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
