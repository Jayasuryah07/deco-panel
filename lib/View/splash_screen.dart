import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/Providers/session_manager.dart';
import '../Data/Services/api_service.dart';
import '../RoutesManagment/routes.dart';
import '../Util/Constant/app_images.dart';
import '../Util/custom/network_connectivity.dart';
import '../Util/custom/network_connectivity_class.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkForUpdate();
    // checkAndRequestCameraPermissions(context);
    getUserData(context);
  }

  Future<void> checkForUpdate() async {
    try {
      if (Platform.isAndroid) {
        _updateInfo = await InAppUpdate.checkForUpdate();
        if (_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          startFlexibleUpdate();
        }
      }
    } catch (e) {
      print("Error checking for updates: $e");
    }
  }

  // Start a flexible update
  Future<void> startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
      print("Update installed successfully.");
    } catch (e) {
      print("Error during update: $e");
    }
  }

  Future<void> getUserData(BuildContext context) async {
    if (!(await NetworkConnectivity.checkInternet())) {
      //  networkDialog(context);
      Get.to(const NoInternetScreen());
      return;
    }
    await ApiService().getdata();
    token = (await SessionManager().getAuthToken()) ?? "";

    await Future.delayed(const Duration(seconds: 1));

    if (token.isEmpty) {
      Get.offAllNamed(RouteConstants.loginScreen);
      return;
    }

    if (token.isNotEmpty && userDetails.data != null) {
      var firebaseToken;
      if (Platform.isIOS) {
        firebaseToken = await FirebaseMessaging.instance.getAPNSToken();
        debugPrint('APNS Token: $token');
      } else {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        firebaseToken = await messaging.getToken();
        debugPrint('APNS Token: $token');
      }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppImages.logo,
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
