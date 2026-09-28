// Routes from page to another page

class OderRoutes {
  // SPLASH SCREEN
  static const splash = '/';
  static const splashChecking = 'splashChecking';
  static const splashLogin = 'splashLogin';
  static const deeplinkWebview = 'deeplink_webview';

  // ONBOARDING SCREEN
  static const onBoard = 'on_boarding';
  // static const onBoard2View = 'on_boarding2_view';
  // static const onBoard3View = 'on_boarding3_view';

  // REGISTER
  static const verifyRegister = 'verify_register';
  static const register = 'register';
  static const otp = 'registerOtp';
  static const otpVerify = 'registerOtp_verify';

  // FORGOT PASSWORD
  static const forgotPassword = 'forgot_pass';
  static const resetPassword = 'reset_pass';

  // LOGIN
  static const login = 'login';

  // // PROFILE ADD AFTER REGISTER
  // static const profileReg = 'profile_reg';
  // // static const profileExtra = 'profile_extra';

  // SETUP VALID AFTER REGISTER (OTP)
  static const setupEValid = 'evalid';
  static const setupEValidOtp = 'evalid_otp';
  static const setupCValid = 'cvalid';
  static const setupCValidOtp = 'cvalid_otp';
  static const setupVProfile = 'vprofile';
  static const setupVMuslim = 'vMuslim';

  // // CONTACT VALID AFTER PROFILE EXTRA
  // static const profileExtraOtp = 'profile_extra_otp';

  // HOMEPAGE
  static const home = 'home';

  // CREDITS PAGE
  static const credits = 'credits';
  static const creditOnline = 'credits_online';
  static const pointConversion = 'point_conversion';

  // VOUCHER REDEEM
  static const reward = 'reward';
  static const rewardDetails = 'reward_detail';
  static const rewardOutletDetails = 'reward_outlet_detail';
  static const rewardDynamicDetails = 'reward_dynamic_dynamic';
  static const rewardConfirm = 'reward_confirm';

  // BULLETINS
  static const bulletin = 'bulletin';
  static const upcoming = 'upcoming';
  static const bulletinDetails = 'bulletin_detail';

  // MY VOUCHER
  static const voucher = 'voucher';
  static const voucherPast = 'voucher_past';
  static const voucherDesc = 'voucher_desc';
  static const voucherManual = 'voucher_manual';
  static const voucherPastDetails = 'voucher_past_details';
  static const voucherfeedback = 'voucher_feedback';

  // WALLET PAGE
  static const wallet = 'wallet';
  static const favDeal = 'fav_deal';
  static const favMerchant = 'fav_merchant';
  static const favOutlet = 'fav_outlet';

  // TRANSFER CREDIT
  static const transferCredit = 'transfer_credit';

  // OUTLET/ ORDERING
  static const orderingMerchant = 'ordering_merchant';
  static const orderingOutlet = 'ordering_outlet';
  static const outletDetails = 'outlet_detail';
  static const brandsChecking = 'brands_checking';
  static const nearbyOutlet = 'nearby_outlet';

  // Nearest Location Outlet
  static const locationOutlet = 'location_outlet';

  // SETTING PAGE
  static const setting = 'setting';

  // MY ACCOUNT PAGE
  static const profile = 'profile';

  // HISTORY
  static const history = 'history';

  // REFER FRIENDS PAGE
  static const refer = 'refer_friends';

  // SECURITY PIN
  static const securityCreate = 'create';
  // static const securityOriginal = 'security_original';
  static const securityChange = 'security_change';
  static const securityOtp = 'security_otp';
  static const securitySet = 'security_Set';
  static const securityConfirm = 'security_confirm';
  static const passcodeKey = 'passcode_key';

  // VERIFY EMAIL
  static const verifyEmail = 'verify_email';
  static const verifyEmailOtp = 'verify_email_otp';

  // DELETE ACCOUNT
  static const deleteAccount = 'delete_account';
  static const deleteMobbile = 'delete_mobile';

  // SCANNER
  static const scannerPage = 'scanner_page'; // OLD
  static const scannerScreen = 'scanner_screen';

  // MAINTENANCE
  static const maintenanceScreen = 'maintenance_screen';

  // SERVICE ERROR
  static const serviceScreen = 'service_screen';

  // SEARCH RESULTS
  static const searchResultsPage = 'search_results_page';
  static const searchAPIPage = 'search_api';
}
