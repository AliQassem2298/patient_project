// constants.dart
const String baseUrl = "http://127.0.0.1:8000";
// "http://192.168.137.120:8000";
//   "http://192.168.1.6:8000";

//"http://192.168.137.166:8000";

formatImageUrl(String rawPath) {
  return "$baseUrl$rawPath";
}

// String? formatImageUrl(String rawPath) {
//   if (rawPath == null || rawPath.isEmpty) return null;
//   return "$baseUrl$rawPath";
// }
