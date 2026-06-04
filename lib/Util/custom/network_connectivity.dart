import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<T?> callIfConnected<T>(Future<T> Function() callback) async {
  ConnectivityResult connectivityResult =
      (await Connectivity().checkConnectivity()).first;

  if ([
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
    ConnectivityResult.ethernet,
  ].contains(connectivityResult)) {
    return await callback();
  } else {
    Get.snackbar(
      "No Internet",
      "Please check your internet connection.",
      snackPosition: SnackPosition.BOTTOM,
    );
    return null;
  }
}

/// Internet Connection Checking
class NetworkConnectivity {
  static Future<bool> checkInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.first == ConnectivityResult.none) return false;

    try {
      final result =
          await http.get(Uri.parse('https://www.google.com')).timeout(
                const Duration(seconds: 5),
              );
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

Future<bool> isConnected() async {
  var connectivityResult = (await Connectivity().checkConnectivity()).first;
  return connectivityResult != ConnectivityResult.none;
}
