class AppUrls {
  static String baseUrl = "https://mis.17000ft.org/apis/fast_apis/";
  static String loginapi = '${AppUrls.baseUrl}login.php';
  static String surveyformapi = '${AppUrls.baseUrl}sbs_questionnaire.php';
  static String loadformapi = '${AppUrls.baseUrl}getForms.php';
   static String imgUploadUrl = '${AppUrls.baseUrl}imgupload.php';
 //  mis.17000ft.org/apis/fast_apis/imgupload.php
 // Endpoint for fetching school names based on UDISE code
static String getSchoolNamesUrl(String udiseCode) {
  return '${baseUrl}pune_schools.php?code=$udiseCode';
}
}