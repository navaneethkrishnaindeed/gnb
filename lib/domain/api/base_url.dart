import '../constants/debug_status.dart';

// ignore: camel_case_types
abstract class API_BaseURL {
  // ignore: constant_identifier_names
  static const TEST_BASE_URL = "https://pixabay.com/api";
  // ignore: constant_identifier_names
  
  // same URL since no UAT servers 
  static const LIVE_BASE_URL = "https://pixabay.com/api";

  static getBaseURL() {
    if (DebugStatus.IS_DEBUG) {
      return TEST_BASE_URL;
    } else {
      return LIVE_BASE_URL;
    }
  }
}
