import 'package:advisorapp/config/dev.dart' as dev;
//import 'package:advisorapp/config/prod.dart' as prod;
import 'package:advisorapp/config/uat.dart' as rel;
import 'package:flutter/foundation.dart';

// When need to release prod build then uncomment line 2 and comment line 3.

class ConnectionConfig {
  static const baseBlobPath =
      kReleaseMode ? rel.AppConfig.baseBlobPath : dev.AppConfig.baseBlobPath;

  static const String webApiserviceURL = kReleaseMode
      ? rel.AppConfig.webApiserviceURL
      : dev.AppConfig.webApiserviceURL;
  static const String microsoftClientId = kReleaseMode
      ? rel.AppConfig.microsoftClientId
      : dev.AppConfig.microsoftClientId;
  static const String microsoftAuthredirectUri = kReleaseMode
      ? rel.AppConfig.microsoftAuthredirectUri
      : dev.AppConfig.microsoftAuthredirectUri;

  static const String basePathOfLogo =
      '${baseBlobPath}advisorimages/employerlogo/';
  static const String defaultimagePath =
      '${baseBlobPath}advisorimages/employerlogo/default.png';
  static const String defaultActionItemPath = '${baseBlobPath}advisorform/';

  static const String defaultIdeaPath = '${baseBlobPath}advisorideas/';
}
