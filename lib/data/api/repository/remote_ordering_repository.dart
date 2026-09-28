import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../data.dart';

// Calling API function for Ordering (FOR CAFE PAGE)
class RemoteOrderingRepository extends OrderingRepository {
  // Get nearby outlet list
  @override
  Future<dynamic> listNearbyOutlet(
    String token,
    String latitude,
    String longitude,
    int offset,
  ) async {
    var param = <String, dynamic>{
      'offset': offset.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'access': 'mobile',
    };
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.nearbyOutlet, param);

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

        return NearbyOutlet.fromEntity(
          NearbyOutletModel.fromJson(jsonResponse['data']),
        );

        // List<dynamic> data = jsonResponse['data']['outlets'] ?? [];
        // List<MerchantList> merchants = [];
        // for (int i = 0; i < data.length; i++) {
        //   merchants.add(
        //       MerchantList.fromEntity(MerchantListModel.fromJson(data[i])));
        // }

        // return merchants;
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

  // Get Brands list
  @override
  Future<dynamic> listBrands(
    String token,
    String latitude,
    String longitude,
    String categoryId,
  ) async {
    var param = <String, dynamic>{
      'categoryId': categoryId.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'access': 'mobile',
    };

    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.brandList, param);

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

        // return MerchantList.fromEntity(
        //     MerchantListModel.fromJson(jsonResponse['data']['merchants']));

        List<dynamic> data = jsonResponse['data']['merchants'] ?? [];
        List<MerchantList> merchants = [];
        for (int i = 0; i < data.length; i++) {
          merchants.add(
            MerchantList.fromEntity(MerchantListModel.fromJson(data[i])),
          );
        }

        // List<dynamic> data = jsonResponse['data']['outlets'] ?? [];
        // List<MerchantList> merchants = [];
        // for (int i = 0; i < data.length; i++) {
        //   merchants.add(
        //       MerchantList.fromEntity(MerchantListModel.fromJson(data[i])));
        // }

        return merchants;
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

  // Get outlet list based on brands
  @override
  Future<dynamic> listOutlets(
    String brandId,
    String latitude,
    String longitude,
    String token,
  ) async {
    var param = <String, dynamic>{
      'merchantId': brandId.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'access': 'mobile',
    };

    var route = HttpClient().createUri(ServerAddresses.brandOutlet, param);
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

        // List<dynamic> data = jsonResponse['data'] ?? [];
        // List<OutletList> outlets = [];
        // for (int i = 0; i < data.length; i++) {
        // outlets.add(OutletList.fromEntity(OutletListModel.fromJson(data[i])));
        // }

        return OutletInfo.fromEntity(
          OutletInfoModel.fromJson(jsonResponse['data']),
        );

        // return outlets;
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

  // Get outlet details
  @override
  Future<dynamic> getDetails(String outletId, String token) async {
    var param = <String, dynamic>{
      'outletId': outletId.toString(),
      'token': token,
      'access': 'mobile',
    };

    var route = HttpClient().createUri(ServerAddresses.outletDetails, param);
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

        return OutletDetails.fromEntity(
          OutletDetailsModel.fromJson(jsonResponse['data']),
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

  // Add/ Remove Favourite (MERCHANT)
  @override
  Future<dynamic> addRemoveBookmark({
    required String token,
    required String merchantId,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.addRemoveBookmark);
    var data = json.encode(<String, String?>{
      'merchantId': merchantId,
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

  // Get favourite (MERCHANT)
  @override
  Future<dynamic> getBookmark({
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
    var route = HttpClient().createUri(ServerAddresses.listBookmark, param);

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

        List<dynamic> data = jsonResponse['data']['merchants'] ?? [];
        List<MerchantBookmark> listBookmark = [];
        for (int i = 0; i < data.length; i++) {
          listBookmark.add(
            MerchantBookmark.fromEntity(
              MerchantBookmarkModel.fromJson(data[i]),
            ),
          );
        }

        return listBookmark;
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

  // Add/ Remove Favourite (OUTLET)
  @override
  Future<dynamic> addRemoveFavOutlet({
    required String token,
    required String outletId,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.addRemoveFavOutlet);
    var data = json.encode(<String, String?>{
      'outletId': outletId,
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

  // Get favourite (OUTLET)
  @override
  Future<dynamic> getFavOutlet({
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
    var route = HttpClient().createUri(ServerAddresses.listFavOutlet, param);

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

        List<dynamic> data = jsonResponse['data']['outlets'] ?? [];
        List<OutletFavourite> listFavourite = [];

        for (int i = 0; i < data.length; i++) {
          listFavourite.add(
            OutletFavourite.fromEntity(OutletFavouriteModel.fromJson(data[i])),
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
