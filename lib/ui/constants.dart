import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
const cornersRadiusConst = 7.0;
const cardLineRadius = 35.0;
const iconsPathConst = 'assets/icons/';
const fontsPath = 'assets/fonts/';
const animationPath = 'assets/animations/';
const imagesPath = 'assets/images/';
var eInvoiceNavIcon = '${imagesPath}einvoiceNavIcon.png';
var eInvoiceBigIcon = '${imagesPath}eInvoiceBigIcon.png';
var eReceiptNavIcon = '${imagesPath}erecieptINavIcon.png';
var eReceiptBigIcon = '${imagesPath}eRecieptBigIcon.png';
var sideMenuIcon = '${iconsPathConst}sideMenuIcon.png';
var rotatedSideMenuIcon = '${iconsPathConst}rotatedSideMenuIcon.png';
var loginTopImage = '${imagesPath}loginTopImg.png';
var logo = '${imagesPath}logo.png';
var whiteLogo = '${imagesPath}whiteLogo.png';
var gmailIcon = '${iconsPathConst}gmailIcon.png';
var whatsappIcon = '${iconsPathConst}wtspIcon.png';
var goIcon = '${iconsPathConst}goicon.png';
var extraBoldFontFamily = '${fontsPath}Almarai_ExtraBold.ttf';
var boldFontFamily = '${fontsPath}Almarai_Bold.ttf';
var lightFontFamily = '${fontsPath}Almarai_Light.ttf';
var regularFontFamily = '${fontsPath}Almarai_Regular.ttf';
var greenDBCardIcon = '${iconsPathConst}greenCardIcon.png';
var lightRedDBCardIcon = '${iconsPathConst}lightCardIcon.png';
var darkRedDBCardIcon = '${iconsPathConst}darkRedCardIcon.png';
var purpleDBCardIcon = '${iconsPathConst}purpleCardIcon.png';
const almarai = 'almarai';
var eInvoiceLottiePath = '${animationPath}eInvoiceAnim.json';
var eReceiptLottiePath = '${animationPath}eReceiptAnim.json';
var welcomeLottiePath = '${animationPath}welcomeAnim.json';

bool isRTL(BuildContext context) {
  return intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
}