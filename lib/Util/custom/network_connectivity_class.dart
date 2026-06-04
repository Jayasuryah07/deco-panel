import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Data/Providers/session_manager.dart';
import '../../Data/Services/api_service.dart';
import '../../RoutesManagment/routes.dart';
import '../../View/auth/login_screen.dart';
import 'network_connectivity.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool isChecking = false;

  /// Timer for 5 seconds to check connection
  @override
  void initState() {
    super.initState();
    /* Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) checkConnection();
    });*/
  }

  /// check network connection
  Future<void> checkConnection() async {
    setState(() => isChecking = true);

    if (await NetworkConnectivity.checkInternet()) {
      debugPrint("Internet connection found");
      await ApiService().getdata();
      token = (await SessionManager().getAuthToken()) ?? "";

      await Future.delayed(const Duration(seconds: 1));

      if (token.isEmpty) {
        Get.offAllNamed(RouteConstants.loginScreen);
        return;
      }

      if (token.isNotEmpty && userDetails.data != null) {
        String? firebaseToken;
        if (Platform.isIOS) {
          firebaseToken = await FirebaseMessaging.instance.getAPNSToken();
          debugPrint('APNS Token: $token');
        } else {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          firebaseToken = await messaging.getToken();
          debugPrint('APNS Token: $token');
        }
        if(!mounted) return;
        await ApiService().loginApi(
          phone: userDetails.data?.user?.mobile ?? "",
          context: context,
          loading: otpController.isLoading,
          password: userDetails.data?.user?.cpassword ?? "",
          deviceId: firebaseToken ?? "",
        );
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        var getType = preferences.getString("userType");

        userType = int.parse(getType ?? "1");

        await ApiService().getdata();
      } else {
        Get.offAllNamed(RouteConstants.loginScreen);
        return;
      }
    } else {
      debugPrint("Internet connection ::::::::not:::::::::: found");
      setState(() => isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img_no_internet.png',
                  width: Get.width * 0.05,
                  height: Get.width * 0.05,
                  //  repeat: true,
                ),
                const SizedBox(height: 24),
                const Text(
                  "You're offline",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please check your internet connection to explore deco panel.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: isChecking ? null : checkConnection,
                  icon: const Icon(Icons.refresh),
                  label: isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("Retry Connection"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                /* OutlinedButton.icon(
                  onPressed: () {
                  //  AppSettings.openAppSettings();
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text("Open Internet Settings"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
