// Abstract repository for security pin

abstract class SecurityRepository {
  Future<dynamic> checkSecurityPin({required String token});

  Future<dynamic> startSecurityPin({
    required String token,
  });

  Future<dynamic> verifySecurityOtp({
    required String token,
    required String otp,
    required String otpToken,
  });

  Future<dynamic> createSecurityPin({
    required String token,
    required String otpToken,
    required String otp,
    required String pin,
  });

  Future<dynamic> verifySecurityPin({
    required String token,
    required String pin,
  });
}
