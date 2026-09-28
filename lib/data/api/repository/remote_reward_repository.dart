import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../data.dart';

// Calling API function for IF PERKS (FOR IF PERKS PAGE)
class RemoteRewardRepository extends RewardRepository {
  // Get filter category list
  @override
  Future<dynamic> filteringCategory(String token) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.filterOptions, param);

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
        }
        // else {
        //   return jsonResponse;
        // }

        if (jsonResponse['data']['filters'].isEmpty) {
          return null;
        } else {
          var filterData = FilterData.fromEntity(
            FilterDataModel.fromJson(
              jsonResponse['data']['filters']['categories'],
            ),
          );

          return filterData;
        }

        // var filterData = FilterData.fromEntity(
        //   FilterDataModel.fromJson(
        //     jsonResponse['data']['filters']['categories'],
        //   ),
        // );

        // return filterData;
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

  // Get IF PERKS list
  @override
  Future<dynamic> listRewards(
    String filterBy,
    String filterValue,
    int offset,
    String token,
  ) async {
    var param = <String, dynamic>{
      'filterBy': filterBy,
      'filterValue': filterValue,
      'offset': offset.toString(),
      'token': token,
      'access': 'mobile',
    };
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.rewardList, param);
    // var route = HttpClient().createUri(ServerAddresses.rewardList);
    // var data = json.encode(<String, String?>{
    //   'filterBy': filterBy,
    //   'filterValue': filterValue,
    //   'offset': offset.toString(),
    //   'token': token,
    //   'access': 'mobile',
    // });

    // RewardData? rewards;

    try {
      var response = await http.get(
        route,
        headers: header,
        // body: data,
      );

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['session']) {
          throw InvalidSessionException(message: jsonResponse['message']);
        }

        if (!jsonResponse['status']) {
          throw InvalidStatusException(message: jsonResponse['message']);
        }

        // jsonResponse['data']['vouchers'] is List
        //     ? rewards = null
        //     : rewards = RewardData.fromEntity(
        //         RewardDataModel.fromJson(jsonResponse['data']));

        // var rewards = RewardData.fromEntity(
        //     RewardDataModel.fromJson(jsonResponse['data']));

        // print('REWARD PRINT: $rewards');

        // return rewards;
        return RewardData.fromEntity(
          RewardDataModel.fromJson(jsonResponse['data']),
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

  // Get IF PERKS list with merchant category
  @override
  Future<dynamic> listRewardsMerchant(String merchantId, String token) async {
    var param = <String, dynamic>{
      'merchantId': merchantId,
      'token': token,
      'access': 'mobile',
    };
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.merchantVoucher, param);

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

        List<dynamic> data = jsonResponse['data']['vouchers'] ?? [];
        List<RewardMerchant> rewards = [];
        for (int i = 0; i < data.length; i++) {
          rewards.add(
            RewardMerchant.fromEntity(RewardMerchantModel.fromJson(data[i])),
          );
        }

        return rewards;
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

  // Get Rewards details
  @override
  Future<dynamic> getDetails(
    String token,
    String rewardId,
    String latitude,
    String longitude,
  ) async {
    var param = <String, dynamic>{
      'id': rewardId.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'access': 'mobile',
    };
    var route = HttpClient().createUri(ServerAddresses.rewardDetails, param);
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

        var details = DetailsData.fromEntity(
          DetailsDataModel.fromJson(jsonResponse['data']),
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

  // Get IF PERKS details with dynamic link code
  @override
  Future<dynamic> getDetailsDynamic(
    String token,
    String code,
    String latitude,
    String longitude,
  ) async {
    var param = <String, dynamic>{
      'code': code,
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'access': 'mobile',
    };

    var route = HttpClient().createUri(ServerAddresses.rewardDetails, param);

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

        var details = DetailsData.fromEntity(
          DetailsDataModel.fromJson(jsonResponse['data']),
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

  // post to DOWNLOAD VOUCHER
  @override
  Future<dynamic> downloadVoucher(
    String voucherId,
    String pin,
    String referral,
    String quantity,
    String token,
  ) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.rewardDownload);
    var data = json.encode(<String, String?>{
      'voucherId': voucherId.toString(),
      'pin': pin,
      'token': token,
      'referral': referral,
      'quantity': quantity,
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

  // post to purchase VOUCHER
  @override
  Future<dynamic> purchaseVoucher(
    String voucherId,
    String redeemVia,
    String pin,
    String points,
    String referral,
    String quantity,
    String token,
  ) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.rewardPurchase);
    var data = json.encode(<String, String?>{
      'voucherId': voucherId.toString(),
      'redeem_via': redeemVia,
      'pin': pin,
      'points': points,
      'referral': referral,
      'quantity': quantity,
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

  @override
  Future<dynamic> redeemRewardQr(String code, String token) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.redeemRewardQr);
    var data = json.encode(<String, String?>{
      'code': code,
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

  // Get brands, vouchers using search function
  @override
  Future<dynamic> searchVouchersBrands({
    required String token,
    String? keywords,
  }) async {
    var param = <String, dynamic>{
      'keywords': keywords,
      'token': token,
      'access': 'mobile',
    };
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(
      ServerAddresses.searchVouchersBrands,
      param,
    );

    try {
      var response = await http.get(route, headers: header);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['isMaintenance'] == true) {
          return jsonResponse; // Returning maintenance response
        }

        if (jsonResponse['session'] == false) {
          throw InvalidSessionException(message: jsonResponse['message']);
        }

        if (jsonResponse['status'] == false) {
          throw InvalidStatusException(message: jsonResponse['message']);
        }

        // var details = jsonResponse['data'];

        return jsonResponse;
      } else {
        throw HttpRequestException();
      }
    } catch (e) {
      if (e is InvalidStatusException || e is InvalidSessionException) {
        rethrow;
      } else {
        throw Exception('Something went wrong. Please try again later.');
      }
    }
  }

  // Add/ Remove Favourite
  @override
  Future<dynamic> addRemoveFavourite({
    required String token,
    required String voucherId,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.addRemoveFavourite);
    var data = json.encode(<String, String?>{
      'voucherId': voucherId,
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

  // Get favourite reward
  @override
  Future<dynamic> getFavourite({
    required String token,
    required String latitude,
    required String longitude,
  }) async {
    var param = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'access': 'mobile',
    };
    var route = HttpClient().createUri(ServerAddresses.listFavourite, param);

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
        // print('LISTFAVOURITE: ${jsonResponse['data']['vouchers']}');

        List<dynamic> data = jsonResponse['data']['vouchers'] ?? [];
        List<RewardFavourite> listFavourite = [];
        for (int i = 0; i < data.length; i++) {
          listFavourite.add(
            RewardFavourite.fromEntity(RewardFavouriteModel.fromJson(data[i])),
          );
        }

        return listFavourite;
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
