import 'dart:async';
import 'package:advisorapp/component/customsnakbar.dart';
import 'package:advisorapp/config/connectionconfig.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

const String webApiserviceURL = ConnectionConfig.webApiserviceURL;

const String microsoftClientId = ConnectionConfig
    .microsoftClientId; // 'a5489f64-06e7-4dfa-920c-196436ea8c46';
const String microsoftAuthredirectUri =
    ConnectionConfig.microsoftAuthredirectUri; //'http://localhost:5000/';

const String basePathOfLogo = ConnectionConfig
    .basePathOfLogo; //'https://advisorformsftp.blob.core.windows.net/advisorimages/employerlogo/';
const String defaultimagePath = ConnectionConfig
    .defaultimagePath; // 'https://advisorformsftp.blob.core.windows.net/advisorimages/employerlogo/default.png';
const String defaultActionItemPath = ConnectionConfig.defaultActionItemPath;
//'https://advisorformsftp.blob.core.windows.net/advisorform/';

const String defaultIdeaPath = ConnectionConfig.defaultIdeaPath;
//'https://advisorformsftp.blob.core.windows.net/advisorideas/';

// add these in a constant file preferably in constant/dimensions.dart
//start of dimensions.dart file
final RegExp mobileValidatorRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
final RegExp emailValidatorRegExp = RegExp(
  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  caseSensitive: false,
  multiLine: false,
);
const String kMobileNullError = "Please Enter your mobile";
const String kInvalidMobileError = "Please Enter Valid Mobile";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String validationFailMessage =
    "One or more validation are failed. Please enter correct values.";
const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const double defaultPadding = 16.0;

//screen sizes
const double widthMobile = 600;
const double widthTablet = 900;
const double widthDesktop = 1024;

const double widthMaxAppWidth = 1200;
const double widthMinAppWidth = 400;

//font sizes
const double fontLarge = 20;
const double fontNormal = 18;
const double fontSmall = 16;
const double fontXSmall = 14;
const double fontXXSmall = 12;
const double fontXXXSmall = 10;

//padding or margins
const double gapXXXSmall = 2;
const double gamXXSmall = 4;
const double gapXSmall = 6;
const double gapSmall = 8;
const double gapXXXNormal = 10;
const double gapXXNormal = 12;
const double gapXNormal = 14;
const double gapNormal = 20;
const double gapLarge = 24;
const double gapLarger = 32;
const double gapLargest = 48;

const errorThemeColor = Color(0xFFB22222);
const themeColorDarkest = Color(0xFFbb3200);
const themeColorDark = Color(0xFFd53900);
const themeColor = Color(0xFFee4000);
const themeColorLighter = Color(0xFFff4b08);
const themeColorLightest = Color(0xFFff5d22);

EdgeInsets defaultSymmetricPadding = EdgeInsets.symmetric(
    vertical: SizeConfig.blockSizeVertical,
    horizontal: SizeConfig.blockSizeHorizontal);

//end of dimensions.dart file
const appstyle12 = TextStyle(fontSize: 12);

const sideMenuAdminStyle = TextStyle(
    color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600);

const appstyle = TextStyle(
    color: AppColors.iconGray, fontSize: 16, fontWeight: FontWeight.bold);
const sideMenuStyle = TextStyle(
    color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600);
const sideGoogleStyle = TextStyle(
    color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600);
const sideMenuStyleSelected = TextStyle(
    backgroundColor: AppColors.primaryBg,
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600);
const invitetextstyle =
    TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);
const hinttextstyle = TextStyle(
    color: AppColors.black, fontSize: 14, fontWeight: FontWeight.bold);

bool isEmailValid(String email) {
  // Define a regular expression pattern for email validation.
  // This pattern checks for basic email format without advanced validation.
  if (email.isEmpty) return true;
  final RegExp regex = emailValidatorRegExp;

  // Use the `hasMatch` method to check if the email matches the pattern.
  return regex.hasMatch(email);
}

bool isSingleValidEmail(String text) {
  // Regular expression to match a single email address
  final emailRegex = emailValidatorRegExp;
  // Check if the text contains only one valid email address
  return emailRegex.allMatches(text).length == 1;
}

bool areValidEmails(String text, String domain) {
  // Regular expression to match a single email address
  final emailRegex = emailValidatorRegExp;

  // Split the input text into individual emails using commas as separators
  List<String> emails = text.split(',');

  // Check if all emails in the list are valid
  for (String email in emails) {
    if (!(emailRegex.hasMatch(email.trim()) && email.split('@')[1] == domain)) {
      return false;
    }
  }

  return true;
}

TextStyle getColoredTextStyle(String parameter) {
  if (parameter == 'noneInProgress' ||
      parameter == 'noneinprogress' ||
      parameter == 'InProgress' ||
      parameter == 'inprogress' ||
      parameter == 'private' ||
      parameter == 'esigninprogress') {
    return const TextStyle(color: AppColors.blue);
  } else if (parameter == 'nonecomplete' ||
      parameter == 'complete' ||
      parameter == 'public' ||
      parameter == 'esigncomplete') {
    return const TextStyle(color: AppColors.green);
  } else if (parameter == 'nonehold' ||
      parameter == 'hold' ||
      parameter == 'canceled' ||
      parameter == 'esigncanceled') {
    return const TextStyle(color: AppColors.red);
  } else if (parameter == 'notsent' ||
      parameter == 'self' ||
      parameter == 'none') {
    return const TextStyle(color: Colors.amber);
  } else {
    return const TextStyle(); // Default TextStyle
  }
}

BoxDecoration toolTipErrorDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    gradient:
        const LinearGradient(colors: <Color>[AppColors.invite, AppColors.red]),
  );
}

ButtonStyle getButtonStyle(String parameter) {
  if (parameter.toUpperCase() == 'INVITED') {
    return ElevatedButton.styleFrom(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ));
  } else if (parameter.toUpperCase() == 'JOINED') {
    return ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ));
  } else {
    return ElevatedButton.styleFrom(
        backgroundColor: AppColors.action,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        )); // Default TextStyle
  }
}

ButtonStyle getButtonLaunchStyle(int daystogo) {
  if (daystogo > 11 && daystogo <= 30) {
    return ElevatedButton.styleFrom(
        backgroundColor: AppColors.invite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ));
  } else if (daystogo >= 0 && daystogo <= 10) {
    return ElevatedButton.styleFrom(
        backgroundColor: AppColors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ));
  } else {
    return ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        )); // Default TextStyle
  }
}

ButtonStyle buttonStyleAmber = ElevatedButton.styleFrom(
    backgroundColor: AppColors.card,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ));
ButtonStyle buttonStyleGrey = ElevatedButton.styleFrom(
    backgroundColor: AppColors.iconGray,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ));

ButtonStyle buttonStyleGreen = ElevatedButton.styleFrom(
    backgroundColor: AppColors.green,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ));
ButtonStyle buttonStyleBlue = ElevatedButton.styleFrom(
    backgroundColor: AppColors.action,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ));

ButtonStyle buttonStyleInvite = ElevatedButton.styleFrom(
  backgroundColor: AppColors.invite,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);
ButtonStyle buttonStyleRed = ElevatedButton.styleFrom(
  backgroundColor: AppColors.red,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);
ButtonStyle buttonStyleTransparent = ElevatedButton.styleFrom(
  backgroundColor: Colors.transparent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);
ButtonStyle roundbuttonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);

BoxDecoration tooltipdecorationGradient = BoxDecoration(
  borderRadius: BorderRadius.circular(25),
  gradient:
      const LinearGradient(colors: <Color>[AppColors.invite, AppColors.red]),
);

BoxDecoration tooltipdecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(25),
  gradient: const LinearGradient(colors: <Color>[
    AppColors.sidemenu,
    AppColors.primaryBg,
    AppColors.sidemenu,
  ]),
);

bool validateEmailDomain(String email, String domainname) {
  if (email.contains("@") && domainname.isNotEmpty) {
    return (email.split('@')[1] == domainname) ? true : false;
  }
  return false;
}

bool checkProhibitedEmailDomain(String email) {
  // Extract the domain from the email
  if (email.contains('@')) {
    final domain = email.split('@').last;

    // Check if the domain matches any of the specified domains
    if (domain == 'gmail.com' ||
        domain == 'rediffmail.com' ||
        domain == 'outlook.com' ||
        domain == 'hotmail.com') {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

bool ifSameDomain(String companydomain, String angainstemail) {
  // Extract the domain from the email
  if (angainstemail.contains('@')) {
    final domain = angainstemail.split('@').last;
    if (domain == companydomain) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

bool checkValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

void showSnackBar(BuildContext context, String comment) {
  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
      content: Text(comment),
    ),
  );
}

void showCustomSnackBar(BuildContext context, String comment) {
  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
        content: CustomSnackBarContent(errorText: comment),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0),
  );
}

Completer<bool> _dialogResultCompleter = Completer<bool>();
// ignore: non_constant_identifier_names
Future<bool> EliteDialog(BuildContext context, String commenttitle,
    String commentcontent, String oxtext, String canceltext) {
  _dialogResultCompleter = Completer<bool>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(commenttitle,
            style: TextStyle(
                color: (commenttitle == 'Warning')
                    ? AppColors.invite
                    : (commenttitle == 'Alert')
                        ? AppColors.red
                        : (commenttitle == 'Please confirm')
                            ? AppColors.action
                            : AppColors.black)),
        content: SizedBox(
          width: SizeConfig.screenWidth / 4,
          child: Text(
            Bidi.hasAnyRtl(commentcontent)
                ? commentcontent
                : Bidi.stripHtmlIfNeeded(commentcontent),
            textAlign: TextAlign.justify,
            textWidthBasis: TextWidthBasis.longestLine,
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: 150,
            child: ElevatedButton(
              style: buttonStyleBlue,
              onPressed: () {
                Navigator.of(context).pop(true); // Return 'Yes' result
              },
              child: Text(oxtext),
            ),
          ),
          (commenttitle == "Alert" || commenttitle == "Warning")
              ? const Text('')
              : SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: canceltext.isEmpty
                        ? buttonStyleTransparent
                        : buttonStyleRed,
                    onPressed: () {
                      Navigator.of(context).pop(false); // Return 'No' result
                    },
                    child: Text(canceltext),
                  )),
        ],
      );
    },
  ).then((value) => _dialogResultCompleter.complete(value));

  return _dialogResultCompleter.future;
}

displaySpin() {
  return SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.grey : Colors.blue,
        ),
      );
    },
  );
}

int calculateDateDifference(String planeffectivedate) {
  DateTime today = DateTime.now();
  DateTime effectiveDate = DateTime.parse(planeffectivedate);

  if (effectiveDate.isAfter(today) || effectiveDate.isAtSameMomentAs(today)) {
    return effectiveDate.difference(today).inDays;
  } else {
    DateTime nextYear = DateTime(
        effectiveDate.year + 1, effectiveDate.month, effectiveDate.day);
    return nextYear.difference(today).inDays;
  }
}

int getCurrentDateDiff(String planeffectivedate) {
  DateTime peffectivedate = planeffectivedate.isEmpty
      ? DateTime.now()
      : DateTime.parse(planeffectivedate);
  DateTime currentdate = DateTime.now();
  return currentdate.difference(peffectivedate).inDays;
}

String convertDateString(String dateString) {
  // Parse the original date string
  if (dateString.isEmpty) {
    return '';
  }
  DateTime dateTime = DateTime.parse(dateString);
  // Format the date as "MM-dd-yyyy"
  String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
  return formattedDate;
}


/* Future<void> showConfirmationDialog(BuildContext context, String title,
    String message, VoidCallback onConfirm) async {
  final confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );

  if (confirmed != null && confirmed) {
    onConfirm();
  }
} */

/* List<Widget> appBarActions(loggedinUser) {
  return [
    IconButton(
      icon: const Icon(Icons.notifications),
      onPressed: () {
        // Add code to show notifications
      },
    ),
    PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: Text(loggedinUser),
          onTap: () {
            // Add code to handle logout
          },
        ),
        PopupMenuItem(
          child: Row(
            children: const [
              Icon(
                Icons.logout_rounded,
                color: AppColors.red,
              ),
              Text('Logout'),
            ],
          ),
          onTap: () {
            // Add code to handle logout
          },
        ),
      ],
    ),
  ];
} */
