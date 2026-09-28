import '../../../domain/domain.dart';

// Abstract repository for user

abstract class UserRepository {
  Future<Map> login({required UserEntity user});

  Future<Map> verifyToken({required String token});

  Future<dynamic> verifyRegister({String? email, String? contact});

  Future<dynamic> register({
    String? email,
    String? contact,
    required String password,
    required String referral,
    required String vToken,
  });

  Future<dynamic> getUserProfile({required String token});

  Future<dynamic> getHomePage({required String token});

  Future<dynamic> getBarcodeProfile({required String token});

  Future<dynamic> getBarcodeRefer({required String token});

  Future<String> getReferCode({required String referCode});

  Future<Map> forgotPassword({String email, String contact});

  Future<dynamic> verifyPasswordOtp({
    required String token,
    required String password,
    required String otpCode,
  });

  Future<Map> generateOtp({
    //string
    required String method,
    required String sendVia,
    required String purpose,
    required String vToken,
  });

  Future<dynamic> verifyOtp({required String token, required String otpCode});

  Future<dynamic> updateProfile({
    required String token,
    required String name,
    required String surname,
    required String forename,
    String? email,
    required String dob,
    required String gender,
  });

  Future<dynamic> updateProfilePhoto({
    required String token,
    required String image,
  });

  Future<Map> sendEmailVerify({required String token, required String email});

  Future<Map> updateEmail({required String token, required String email});

  Future<Map> updateContact({required String token, required String contact});

  Future<Map> updateMuslimFriendly({
    required String token,
    required bool isMuslim,
  });

  Future<dynamic> deleteAcc({
    required String token,
    required String reason,
    required String email,
  });

  Future<dynamic> searchFunction({
    required String token,
    String? keywords,
    String? type,
  });

  // Future<bool> changePassword(
  //     {required String token, required String password});

  // Future<bool> changeAddress({
  //   required String token,
  //   required String address1,
  //   required String address2,
  //   required String city,
  //   required String postal,
  //   required String states,
  //   required String country,
  // });
}
