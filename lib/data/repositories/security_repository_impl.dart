import '../data.dart';

// Repository for security pin

class SecurityRepositoryImpl extends SecurityRepository {
  final RemoteSecurityRepository remoteSecurityRepository;

  SecurityRepositoryImpl({required this.remoteSecurityRepository});

  @override
  Future<dynamic> checkSecurityPin({required String token}) async {
    try {
      return remoteSecurityRepository.checkSecurityPin(token: token);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<dynamic> startSecurityPin({required String token}) async {
    return remoteSecurityRepository.startSecurityPin(token: token);
  }

  @override
  Future<dynamic> verifySecurityOtp({
    required String token,
    required String otp,
    required String otpToken,
  }) async {
    return remoteSecurityRepository.verifySecurityOtp(
      token: token,
      otp: otp,
      otpToken: otpToken,
    );
  }

  @override
  Future<dynamic> createSecurityPin({
    required String token,
    required String otpToken,
    required String otp,
    required String pin,
  }) async {
    return remoteSecurityRepository.createSecurityPin(
      token: token,
      otpToken: otpToken,
      otp: otp,
      pin: pin,
    );
  }

  @override
  Future<dynamic> verifySecurityPin({
    required String token,
    required String pin,
  }) async {
    return remoteSecurityRepository.verifySecurityPin(token: token, pin: pin);
  }
}
