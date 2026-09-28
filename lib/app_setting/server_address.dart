// Server address and API url

// import 'package:config/config_main.dart';

import '../config/config.dart';

class ServerAddresses {
  static const String apiVersionDefault = AppConfig.apiVersionDefault;

  /* -------------------------- Oder API ADDRESS ----------------------- */

  /* -----------------------------------------------------------------GENERAL */
  // Get country code
  static const country = '$apiVersionDefault/countries';

  /* ------------------------------------------------------------------GLOBAL */
  // Get global
  static const global = '$apiVersionDefault/global';

  /* ----------------------------------------------------------------------OTP*/
  // Generate the otp
  static const generateOtp = '$apiVersionDefault/otp/generate';
  // Verify the otp entered
  static const verifyOtp = '$apiVersionDefault/otp/verify';

  /* ---------------------------------------------------USER REGISTER & LOGIN */
  // Verify user phone/email to get vToken
  static const verifyRegister = '$apiVersionDefault/register/verify';
  // User register
  static const register = '$apiVersionDefault/register';
  // User login
  static const login = '$apiVersionDefault/login';
  // User verify token
  static const verify = '$apiVersionDefault/login/verify';

  /* ----------------------------------------------------------FORGOT PASSWORD*/
  // Pass mobile no parameter
  static const forgot = '$apiVersionDefault/forgot';
  // Pass the otp, token, new password
  static const reset = '$apiVersionDefault/forgot/reset';

  /* ------------------------------------------------------------PROFILE SETUP*/
  //
  static const updateEmail = '$apiVersionDefault/user/profile/email';
  static const updateContact = '$apiVersionDefault/user/profile/contact';
  static const updateMuslimFriendly =
      '$apiVersionDefault/user/profile/muslim_friendly';

  /* -----------------------------------------------------------------HOMEPAGE*/
  // Get homepage data
  static const getHomepage = '$apiVersionDefault/user/homepage';

  /* ------------------------------------------------------------USER PROFILE */
  // Get user profile
  static const profile = '$apiVersionDefault/user/profile';
  // Upload/Update user profile photo
  static const profilePhoto = '$apiVersionDefault/user/profile/upload';
  // Update user profile (Will use in profile setting)
  static const profileUpdate = '$apiVersionDefault/user/profile/update';
  // // Update user profile (Will use in profile register)
  // static const profileRegUpdate = '$apiVersionDefault/user/profile/new';
  // Delete user account
  static const deleteAccount = '$apiVersionDefault/user/profile/delete';
  // Get user IF Card data
  static const qrcode = '$apiVersionDefault/user/card';

  /* ------------------------------------------------------------REFFERAL CODE*/
  // Get user refferal code (in encryption data)
  static const refer = '$apiVersionDefault/user/referral';
  // Decrypt user refferal code
  static const referDecrypt = '$apiVersionDefault/qr';

  /* -------------------------------------------------------------USER VOUCHER*/
  // Get my voucher list
  static const myVoucherList = '$apiVersionDefault/user/vouchers';
  // Get my voucher details
  static const voucherDetails = '$apiVersionDefault/user/voucher_detail';
  // // Get My voucher past
  static const voucherPast = '$apiVersionDefault/user/voucher_history';
  // // Get My voucher past detail
  static const voucherPastDetail =
      '$apiVersionDefault/user/voucher_history_detail';
  // Redeem voucher by slide button or qr scan
  static const redeemVoucher = '$apiVersionDefault/user/redeem_vouchers';
  // Send voucher review
  static const voucherReview = '$apiVersionDefault/user/voucher_review';

  /* ------------------------------------------------------REDEEM REWARD(SCAN)*/
  // Scan Qr code reward data or manually insert voucher code
  static const redeemRewardQr = '$apiVersionDefault/user/redeem_rewards';

  /* -------------------------------------------------------------SECURITY PIN*/
  // Check security pin (already register or not)
  static const checkSecurityPin = '$apiVersionDefault/user/security/check';
  // Send otp code to registered mobile no
  static const startSecurityPin = '$apiVersionDefault/user/security/start';
  // Verify otp code
  static const verifySecurityOtp =
      '$apiVersionDefault/user/security/verify_otp';
  // Register security pin
  static const createSecurityPin = '$apiVersionDefault/user/security/pin';
  // Verify security pin entered
  static const verifySecurityPin =
      '$apiVersionDefault/user/security/verify_pin';

  /* -----------------------------------------------------------------BULLETIN*/
  // Show bulletin List
  static const bulletinList = '$apiVersionDefault/bulletin_boards/';
  // Show bulletin details
  static const bulletinDetail = '$apiVersionDefault/bulletin_boards/details';

  /* -----------------------------------------------------------REDEEM VOUCHER*/

  // // Get redeem voucher wih merchant categories
  // static const rewardMerchant = '$apiVersionDefault/vouchers/merchant';
  // Show vouchers reward list
  static const rewardList = '$apiVersionDefault/vouchers/lists';
  // Show IF Perks details
  static const rewardDetails = '$apiVersionDefault/vouchers/details';
  // Download voucher(If downloadble)
  static const rewardDownload = '$apiVersionDefault/vouchers/download';
  // // Show IF Perks list
  // static const rewardList = '$apiVersionDefault/vouchers/purchase';
  // Redeem/purchase voucher
  static const rewardPurchase = '$apiVersionDefault/vouchers/purchase';
  // Show filter options
  static const filterOptions = '$apiVersionDefault/vouchers/filters';
  // Add/remove favourite
  static const addRemoveFavourite = '$apiVersionDefault/vouchers/favourite';
  // List favourite
  static const listFavourite = '$apiVersionDefault/vouchers/favourite';

  /* ------------------------------------------------------------LOCATION CAFE*/
  // Show merchant/brands list
  static const brandList = '$apiVersionDefault/locations/merchants';
  // Show nearby outlet list
  static const nearbyOutlet = '$apiVersionDefault/locations/nearby';
  // Show outlet based on merchant/brands
  static const brandOutlet = '$apiVersionDefault/locations/outlets';
  // Get redeem voucher wih merchant categories
  static const merchantVoucher =
      '$apiVersionDefault/locations/merchant_vouchers';
  // Show outlet details
  static const outletDetails = '$apiVersionDefault/locations/outlet_details';
  // Add/remove favourite (MERCHANT)
  static const addRemoveBookmark = '$apiVersionDefault/locations/favourite';
  // list favourite (MERCHANT)
  static const listBookmark = '$apiVersionDefault/locations/favourite';
  // Add/remove favourite (OUTLET)
  static const addRemoveFavOutlet =
      '$apiVersionDefault/locations/outlet_favourite';
  // list favourite (OUTLET)
  static const listFavOutlet = '$apiVersionDefault/locations/outlet_favourite';

  /* ------------------------------------------------------------ VERIFY EMAIL*/
  // Send user email
  static const sendEmailVerify = '$apiVersionDefault/user/email/send';

  /* ------------------------------------------------------------------HISTORY*/
  // Show point history list
  static const pointHistoryList = '$apiVersionDefault/user/transactions/points';
  // Show credit history list
  static const creditHistoryList =
      '$apiVersionDefault/user/transactions/credits';

  /* -------------------------------------------------------------------SEARCH*/
  // Search merchant and voucher
  static const searchVouchersBrands = '$apiVersionDefault/user/search';
  static const searchFunction = '$apiVersionDefault/user/search';

  /* -----------------------------------------------------------CREDIT/PAYMENT*/
  // Show payment qr code
  static const creditPayment = '$apiVersionDefault/user/credits/payment';
  // Point conversion (point to credit)
  static const pointConversion = '$apiVersionDefault/user/points/convert';

  /* --------------------------------------------------------------------------- SO FAR NOT USE */
  // Get url for online banking/ Fpx
  static const creditOnlineTopup = '$apiVersionDefault/user/payment/initial';

  /* ----------------------------------------------------------TRANSFER CREDIT*/

  // Send credit to others
  static const verifyTransfer = '$apiVersionDefault/user/credits/verify';
  // Send credit to others
  static const transferCredit = '$apiVersionDefault/user/credits/transfer';
}
