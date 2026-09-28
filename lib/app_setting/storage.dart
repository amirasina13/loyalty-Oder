import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final Storage _instance = Storage._internal();

  factory Storage() => _instance;

  Storage._internal();

  // STORAGE
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String token = '';
  String otpToken = '';
  String contact = '';
  String email = '';
  String otp = '';
  String? distance = '';
  String? page = '';
  String reasonDelete = '';
  String lastUpdateCheck = '';
  String lastUpdateLoc = '';
  String set = '';
  String? brandName = '';
  String securityPin = '';
  String rewardId = '';
  String voucherId = '';
  String merchantId = '';
  String? titlePasscodeRoute = '';
  String? welcomeSplash = '';
  String rewardReload = '';
  String? latitude = '3.1390';
  String? longitude = '101.6869';
  String? address = '';
  String? locPermission = '';
  Map? globalValue;
  int? orderingCheck = 0;
  Map? dataCheck;
  bool? setupDone;
  bool? isTabChange = false;
  String? referralCode = '';

  void clearSessionData() {
    token = '';
    otpToken = '';
    // contact = '';
    // email = '';
    otp = '';
    securityPin = '';
    reasonDelete = '';
    brandName = '';
    rewardId = '';
    voucherId = '';
    merchantId = '';
    titlePasscodeRoute = '';
    welcomeSplash = '';
    rewardReload = '';
    globalValue = null;
    orderingCheck = 0;
    dataCheck = null;
    setupDone = null;
    isTabChange = false;
  }
}
