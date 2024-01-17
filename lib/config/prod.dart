class AppConfig {
  static const baseBlobPath =
      'https://advisorprodstorage.blob.core.windows.net/';
  static const String webApiserviceURL =
      "https://advisorwebapiprod.azurewebsites.net/api/";
  static const String microsoftClientId =
      'c037b070-beca-4c16-8850-4a6694ddd2ea';
  static const String microsoftAuthredirectUri = 'https://advisor.alicorn.co/';

  static const String basePathOfLogo =
      '${baseBlobPath}advisorimages/employerlogo/';
  static const String defaultimagePath =
      '${baseBlobPath}advisorimages/employerlogo/default.png';
  static const String defaultActionItemPath = '${baseBlobPath}advisorform/';

  static const String defaultIdeaPath = '${baseBlobPath}advisorideas/';
}
