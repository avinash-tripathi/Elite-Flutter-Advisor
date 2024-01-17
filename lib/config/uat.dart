class AppConfig {
  static const baseBlobPath = 'https://advisorformsftp.blob.core.windows.net/';
  static const String webApiserviceURL =
      "https://advisorsandbox.azurewebsites.net/api/";
  static const String microsoftClientId =
      '1087cdb1-0c33-4e7f-9c79-24d674d0165f';
  static const String microsoftAuthredirectUri = 'http://localhost:5000/';
  static const String basePathOfLogo =
      '${baseBlobPath}advisorimages/employerlogo/';
  static const String defaultimagePath =
      '${baseBlobPath}advisorimages/employerlogo/default.png';
  static const String defaultActionItemPath = '${baseBlobPath}advisorform/';
  static const String defaultIdeaPath = '${baseBlobPath}advisorideas/';
}
