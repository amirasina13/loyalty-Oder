import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app_setting/app_setting.dart';
import '../../../domain/domain.dart';
import '../../data.dart';

// Calling API function for User
class RemoteUserRepository extends UserRepository {
  // Login API
  @override
  Future<Map> login({required UserEntity user}) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.login);
    var data = json.encode(user.toMap());

    try {
      var response = await http.post(route, headers: header, body: data);

      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200 ||
          (jsonResponse['isMaintenance'] == false && !jsonResponse['status'])) {
        throw jsonResponse['message'];
      }

      // if got key image, set the Storage().welcomeSplash to new image. Else set to empty string
      if (jsonResponse['data']?.containsKey('image') == true) {
        Storage().welcomeSplash = jsonResponse['data']['image'];
      } else {
        Storage().welcomeSplash = '';
      }

      return jsonResponse;
    } catch (e) {
      if (e is InvalidStatusException) {
        throw Exception(e.message);
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later.');
      } else {
        rethrow;
      }
    }
  }

  // Login token verify
  @override
  Future<Map> verifyToken({required String token}) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.verify, param);

    try {
      var response = await http.get(route, headers: header);
      Map jsonResponse = json.decode(response.body);

      if (response.statusCode != 200 ||
          (jsonResponse['isMaintenance'] == false && !jsonResponse['status'])) {
        throw jsonResponse['message'];
      }

      if (jsonResponse['isMaintenance'] == false) {
        // If got key image, set the Storage().welcomeSplash to new image. Else set to empty string
        if (jsonResponse['data']?.containsKey('image') == true) {
          Storage().welcomeSplash = jsonResponse['data']['image'];
        } else {
          Storage().welcomeSplash = '';
        }
      }

      return jsonResponse;
    } catch (e) {
      if (e is InvalidStatusException) {
        throw Exception(e.message);
      } else if (e is InvalidSessionException) {
        throw Exception(e.message);
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later.');
      } else {
        rethrow;
      }
    }
  }

  // Get user profile
  @override
  Future<dynamic> getUserProfile({required String token}) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.profile, param);

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

        return UserProfile.fromEntity(
          UserProfileModel.fromJson(jsonResponse['data']),
        );
      } else {
        throw HttpRequestException();
      }
    } catch (e) {
      if (e is InvalidStatusException) {
        throw Exception(e.message);
      } else if (e is InvalidSessionException) {
        throw Exception(e.message);
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later.');
      } else {
        rethrow;
      }
    }
  }

  // Get Homepage API
  @override
  Future<dynamic> getHomePage({required String token}) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.getHomepage, param);

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

        return HomePage.fromEntity(
          HomePageModel.fromJson(jsonResponse['data']),
        );
      } else {
        throw HttpRequestException();
      }
    } catch (e) {
      if (e is InvalidStatusException) {
        throw Exception(e.message);
      } else if (e is InvalidSessionException) {
        throw Exception(e.message);
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later.');
      } else {
        rethrow;
      }
    }
  }

  // Get IF Card data
  @override
  Future<dynamic> getBarcodeProfile({required String token}) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.qrcode, param);

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

        return UserQrcode.fromEntity(
          UserMembercardeModel.fromJson(jsonResponse['data']),
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

  // Get referral code (in encryption data)
  @override
  Future<dynamic> getBarcodeRefer({required String token}) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.refer, param);

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

        return UserRefer.fromEntity(
          UserReferModel.fromJson(jsonResponse['data']),
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

  // Get referral code API(from decrypt to real code)                             * No isMaintenance check
  @override
  Future<String> getReferCode({required String referCode}) async {
    var param = <String, dynamic>{'code': referCode};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.referDecrypt, param);

    try {
      var response = await http.get(route, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data']['code'];
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

  // Verify Register API
  @override
  Future<dynamic> verifyRegister({String? email, String? contact}) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.verifyRegister);
    var data = json.encode(<String, String?>{
      'email': email,
      'contact': contact,
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

  // Register user API
  @override
  Future<dynamic> register({
    String? email,
    String? contact,
    required String password,
    required String referral,
    required String vToken,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.register);
    var data = json.encode(<String, String?>{
      'email': email,
      'contact': contact,
      'password': password,
      'referral': referral,
      'vToken': vToken,
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

  // Generate OTP API                                                             * Not testing yet
  @override
  Future<Map> generateOtp({
    required String method, //email or contact
    required String sendVia,
    required String purpose,
    required String vToken,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.generateOtp);
    var data = json.encode(<String, String?>{
      'send_to': method,
      'send_via': sendVia,
      'purpose': purpose,
      'vToken': vToken,
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        // var status = jsonResponse['status'];

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['status']) {
            throw InvalidStatusException(message: jsonResponse['message']);
          }
        }

        // return jsonResponse['data']['token'];
        return jsonResponse;
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

  // Verify OTP API
  @override
  Future<dynamic> verifyOtp({
    required String token,
    required String otpCode,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.verifyOtp);
    var data = json.encode(<String, String?>{'token': token, 'otp': otpCode});

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          var status = jsonResponse['status'];

          if (!status) {
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

  // Forgot password API
  @override
  Future<Map> forgotPassword({String? email, String? contact}) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.forgot);
    var data = json.encode(<String, String?>{
      'email': email,
      'contact': contact,
    });

    try {
      var response = await http.post(route, headers: header, body: data);
      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200 ||
          (jsonResponse['isMaintenance'] == false && !jsonResponse['status'])) {
        throw jsonResponse['message'];
      }

      return jsonResponse;
      // return jsonResponse;
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

  // Reset password API
  @override
  Future<dynamic> verifyPasswordOtp({
    required String token,
    required String password,
    required String otpCode,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.reset);
    var data = json.encode(<String, String?>{
      'token': token,
      'password': password,
      'otp': otpCode,
    });

    try {
      var response = await http.post(route, headers: header, body: data);
      Map jsonResponse = json.decode(response.body);
      if (response.statusCode != 200 ||
          (jsonResponse['isMaintenance'] == false && !jsonResponse['status'])) {
        throw jsonResponse['message'];
      }

      // var status = jsonResponse['status'];

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

  // Update profile data (setting)
  @override
  Future<dynamic> updateProfile({
    required String token,
    required String name,
    required String surname,
    required String forename,
    String? email,
    required String dob,
    required String gender,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.profileUpdate);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'surname': surname,
      'forename': forename,
      'name': name,
      'email': email,
      'dob': dob,
      'gender': gender,
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          var status = jsonResponse['status'];

          if (!status) {
            throw jsonResponse['message'];
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

  // Update profile photo
  @override
  Future<dynamic> updateProfilePhoto({
    required String token,
    required String image,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.profilePhoto);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'image': 'data:image/jpeg;base64,$image',
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          var status = jsonResponse['status'];

          if (!status) {
            throw jsonResponse['message'];
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

  // Send email verification
  @override
  Future<Map> sendEmailVerify({
    required String token,
    required String email,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.sendEmailVerify);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'send_to': email,
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          var status = jsonResponse['status'];

          if (!status) {
            throw jsonResponse['message'];
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

  // Update profile Email
  @override
  Future<Map> updateEmail({
    required String token,
    required String email,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.updateEmail);
    var data = json.encode(<String, dynamic>{
      'token': token,
      'access': 'mobile',
      'email': email,
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          var status = jsonResponse['status'];

          if (!status) {
            throw jsonResponse['message'];
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

  // Update profile Contact
  @override
  Future<Map> updateContact({
    required String token,
    required String contact,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.updateContact);
    var data = json.encode(<String, dynamic>{
      'token': token,
      'access': 'mobile',
      'contact': contact,
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          var status = jsonResponse['status'];

          if (!status) {
            throw jsonResponse['message'];
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

  // Update profile Muslim Friendly
  @override
  Future<Map> updateMuslimFriendly({
    required String token,
    required bool isMuslim,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.updateMuslimFriendly);
    var data = json.encode(<String, dynamic>{
      'token': token,
      'access': 'mobile',
      'isMuslim': isMuslim,
    });

    try {
      var response = await http.post(route, headers: header, body: data);

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          var status = jsonResponse['status'];

          if (!status) {
            throw jsonResponse['message'];
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

  // Delete account
  @override
  Future<dynamic> deleteAcc({
    required String token,
    required String reason,
    required String email,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.deleteAccount);
    var data = json.encode(<String, String?>{
      'email': email,
      'reason': reason,
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

  // Get brands, vouchers using search function
  @override
  Future<dynamic> searchFunction({
    required String token,
    String? keywords,
    String? type,
  }) async {
    var param = <String, dynamic>{
      'keywords': keywords,
      'type': type,
      'token': token,
      'access': 'mobile',
    };
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.searchFunction, param);

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
}
