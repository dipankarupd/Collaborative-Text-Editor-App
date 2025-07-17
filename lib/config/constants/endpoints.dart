import 'package:app/config/constants/app_constants.dart';

abstract class AppEndpoints {
  // Auth:
  static const LOGIN = "${AppConstants.APP_URL}/users/login";
  static const Google_LOGIN = "${AppConstants.APP_URL}/users/login/google";
  static const REGISTER = "${AppConstants.APP_URL}/users/register";
  static const ME = "${AppConstants.APP_URL}/users/me";
  static const REFRESH = "${AppConstants.APP_URL}/refresh";
  static const LOGOUT = "${AppConstants.APP_URL}/users/logout";

  // Document:
  static const DOCUMENTS = "${AppConstants.APP_URL}/documents/me";
  static const CREATE = "${AppConstants.APP_URL}/documents";
  static updateTitle(String docId) =>
      "${AppConstants.APP_URL}/documents/$docId";

  static GetDocumentById(String docId) =>
      "${AppConstants.APP_URL}/documents/$docId";
}
