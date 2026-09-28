import 'storage.dart';

/* ------------------------- APP GLOBAL LABELLING --------------------------- */

final global = Storage().globalValue!;

final isMaintenance = global['isMaintenance'];
final isMuslimFriendly = global['isMuslimFriendly'];
final isEmailRequired = global['isEmailRequired'];
final isContactRequired = global['isContactRequired'];
final registerMethod = global['registerMethod'];
final scanning = global['scanning'];
final msgMaintenance = global['msg_maintenance'];

// ------------------------------------------------------------------ SOCIAL URL
final urlWebsite = global['url']['Website'];
final urlInstagram = global['url']['Instagram'];
final urlFacebook = global['url']['Facebook'];
final urlAboutUs = global['url']['AboutUs'];
final urlTerm = global['url']['Term'];
final urlPolicy = global['url']['Policy'];
final urlFAQ = global['url']['FAQ'];
final urlPDPA = global['url']['PDPA'];

// ----------------------------------------------------------------- CREDIT PART
// Credits enable
final creditEnable = global['credits']['enable'];
// Credits topup enable
final creditTopup = global['credits']['topup'];
// Credits transfer enable
final creditTransfer = global['credits']['transfer'];
// Credits payment enable
final creditPayment = global['credits']['payment'];
// Credits history enable
final creditHistoryEnable = global['credits']['history'];
// Credits selection (topup)
final creditSelection = global['credits']['selection'];
// Credits label title
final creditLabelTitle = global['credits']['labeling']['Title'];
// Credits label text
final creditLabelText = global['credits']['labeling']['Text'];
// Credits label align
final creditLabelAlign = global['credits']['labeling']['Align'];

// ------------------------------------------------------------------ POINT PART
// Points enable
final pointEnable = global['points']['enable'];
// Points earning enable
final pointEarning = global['points']['earning'];
// Points convert enable
final pointConvert = global['points']['convert'];
// Points convert rate
final pointConvertRate = global['points']['convert_rate'];
// Points history enable
final pointHistory = global['points']['history'];
// Points label title
final pointLabelTitle = global['points']['labeling']['Title'];
// Points label text
final pointLabelText = global['points']['labeling']['Text'];
// Points label align
final pointLabelAlign = global['points']['labeling']['Align'];

// ------------------------------------------------------------------ COINS PART
// Coins enable
final coinEnable = global['coins']['enable'];
// Coins label title
final coinLabelTitle = global['coins']['labeling']['Title'];
// Coins label text
final coinLabelText = global['coins']['labeling']['Text'];
// Coins label align
final coinLabelAlign = global['coins']['labeling']['Align'];
