import '../../domain/domain.dart';
import '../data.dart';
// Repository for user

class UserRepositoryImpl extends UserRepository {
  final RemoteUserRepository remoteUserRepository;

  UserRepositoryImpl({required this.remoteUserRepository});

  @override
  Future<Map> login({required UserEntity user}) async {
    return remoteUserRepository.login(user: user);
  }

  @override
  Future<Map> verifyToken({required String token}) async {
    return remoteUserRepository.verifyToken(token: token);
  }

  @override
  Future<dynamic> getUserProfile({required String token}) async {
    try {
      return remoteUserRepository.getUserProfile(token: token);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getHomePage({required String token}) async {
    try {
      return remoteUserRepository.getHomePage(token: token);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getBarcodeProfile({required String token}) async {
    try {
      return remoteUserRepository.getBarcodeProfile(token: token);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getBarcodeRefer({required String token}) async {
    try {
      return remoteUserRepository.getBarcodeRefer(token: token);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> getReferCode({
    //string
    required String referCode,
  }) async {
    return remoteUserRepository.getReferCode(referCode: referCode);
  }

  @override
  Future<dynamic> verifyRegister({
    //string
    String? email,
    String? contact,
  }) async {
    return remoteUserRepository.verifyRegister(email: email, contact: contact);
  }

  @override
  Future<dynamic> register({
    //string
    String? email,
    String? contact,
    required String password,
    required String referral,
    required String vToken,
  }) async {
    return remoteUserRepository.register(
      email: email,
      contact: contact,
      password: password,
      referral: referral,
      vToken: vToken,
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<dynamic> verifyOtp({
    required String token,
    required String otpCode,
  }) async {
    return remoteUserRepository.verifyOtp(token: token, otpCode: otpCode);
  }

  @override
  Future<Map> forgotPassword({String? email, String? contact}) async {
    return remoteUserRepository.forgotPassword(email: email, contact: contact);
  }

  @override
  Future<dynamic> verifyPasswordOtp({
    required String token,
    required String password,
    required String otpCode,
  }) async {
    return remoteUserRepository.verifyPasswordOtp(
      token: token,
      password: password,
      otpCode: otpCode,
    );
  }

  @override
  Future<Map> generateOtp(
  //string
  {
    required String method,
    required String sendVia,
    required String purpose,
    required String vToken,
  }) async {
    return remoteUserRepository.generateOtp(
      method: method,
      sendVia: sendVia,
      purpose: purpose,
      vToken: vToken,
    );
  }

  // // Repository for profile register
  // @override
  // Future<Map> updateRegProfile({
  //   required String token,
  //   required String name,
  //   required String surname,
  //   required String forename,
  //   required String contact,
  //   required String dob,
  //   required String gender,
  //   bool? isMuslim,
  //   required bool vMuslim,
  //   required bool vExtra,
  //   required bool vProfile,
  // }) async {
  //   return remoteUserRepository.updateRegProfile(
  //     token: token,
  //     name: name,
  //     surname: surname,
  //     forename: forename,
  //     contact: contact,
  //     dob: dob,
  //     gender: gender,
  //     isMuslim: isMuslim!,
  //     vMuslim: vMuslim,
  //     vExtra: vExtra,
  //     vProfile: vProfile,
  //   );
  // }

  // Repository for profile update (setting)
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
    return remoteUserRepository.updateProfile(
      token: token,
      name: name,
      surname: surname,
      forename: forename,
      email: email,
      dob: dob,
      gender: gender,
    );
  }

  @override
  Future<dynamic> updateProfilePhoto({
    required String token,
    required String image,
  }) async {
    return remoteUserRepository.updateProfilePhoto(token: token, image: image);
  }

  @override
  Future<Map> sendEmailVerify({
    required String token,
    required String email,
  }) async {
    return remoteUserRepository.sendEmailVerify(token: token, email: email);
  }

  // Repository for email setup
  @override
  Future<Map> updateEmail({
    required String token,
    required String email,
  }) async {
    return remoteUserRepository.updateEmail(token: token, email: email);
  }

  // Repository for contact setup
  @override
  Future<Map> updateContact({
    required String token,
    required String contact,
  }) async {
    return remoteUserRepository.updateContact(token: token, contact: contact);
  }

  // Repository for muslim friendly setup
  @override
  Future<Map> updateMuslimFriendly({
    required String token,
    required bool isMuslim,
  }) async {
    return remoteUserRepository.updateMuslimFriendly(
      token: token,
      isMuslim: isMuslim,
    );
  }

  @override
  Future<dynamic> deleteAcc({
    required String token,
    required String reason,
    required String email,
  }) async {
    return remoteUserRepository.deleteAcc(
      token: token,
      reason: reason,
      email: email,
    );
  }

  @override
  Future<dynamic> searchFunction({
    required String token,
    String? keywords,
    String? type,
  }) async {
    return remoteUserRepository.searchFunction(
      token: token,
      keywords: keywords,
      type: type,
    );
  }
}
