class AppConfig {
  static const baseBlobPath = 'https://advisorformsftp.blob.core.windows.net/';
  static const String webApiserviceURL =
      "https://advisordevelopment.azurewebsites.net/api/";
  static const String microsoftClientId =
      'a5489f64-06e7-4dfa-920c-196436ea8c46';
  static const String microsoftAuthredirectUri = 'http://localhost:5000/';

  static const String basePathOfLogo =
      '${baseBlobPath}advisorimages/employerlogo/';
  static const String defaultimagePath =
      '${baseBlobPath}advisorimages/employerlogo/default.png';
  static const String defaultActionItemPath = '${baseBlobPath}advisorform/';

  static const String defaultIdeaPath = '${baseBlobPath}advisorideas/';
}
