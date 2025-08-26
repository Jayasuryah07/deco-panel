import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/Providers/session_manager.dart';
import '../Data/Services/api_service.dart';
import '../RoutesManagment/routes.dart';
import '../Util/Constant/app_colors.dart';
import '../Util/Constant/app_size.dart';
import '../Util/custom/network_connectivity.dart';
import '../Util/custom/network_connectivity_class.dart';
import '../widget/common_button.dart';
import 'auth/login_screen.dart';

class SplashCommonPage extends StatefulWidget {
  const SplashCommonPage({super.key});

  @override
  State<SplashCommonPage> createState() => _SplashCommonPageState();
}

class _SplashCommonPageState extends State<SplashCommonPage> {
  @override
  void initState() {
    super.initState();
    // Set the timer for 2 seconds before navigating to the next screen

    checkForUpdate();
    // checkAndRequestCameraPermissions(context);
    getUserData(context);
  }

  AppUpdateInfo? _updateInfo;

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
      debugPrint("Error checking for updates: $e");
    }
  }

  // Start a flexible update
  Future<void> startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
      debugPrint("Update installed successfully.");
    } catch (e) {
      debugPrint("Error during update: $e");
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
        context: this.context,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/AGS_LOGO.png",
                  height: Get.height * 0.15,
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                RichText(
                  text: TextSpan(
                    text: "AG ",
                    style: GoogleFonts.roboto(
                      fontSize: Get.height / 28,
                      color: const Color(0xFF076894),
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      TextSpan(
                        text: "Solutions",
                        style: GoogleFonts.roboto(
                          fontSize: Get.height / 28,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFF076894),
            child: Text(
              "WEBSITE | WEB APPLICATION\nMOBILE APPLICATION | DIGITAL MARKETING",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: Get.height / 50,
                color: const Color(0xFFffffff),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.15,
          ),
          //  CircularProgressIndicator(color: ,),
        ],
      ),
    );
  }
}

void networkDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Log Out",
          style: GoogleFonts.ptSans(
            fontSize: Get.height / 45,
            fontWeight: FontWeight.w700,
            color: AppColors.color333,
          ),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: GoogleFonts.ptSans(
            fontSize: Get.height / 55,
            fontWeight: FontWeight.w400,
            color: AppColors.color333,
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  padding: EdgeInsets.zero,
                  height: AppSize.displayHeight(context) * 0.05,
                  boxShadowColor: Colors.transparent,
                  enabledColor: AppColors.whiteColor,
                  textStyle: GoogleFonts.poppins(
                    fontSize: Get.height / 65,
                    fontWeight: FontWeight.w700,
                    color: AppColors.colorB5B,
                  ),
                  text: "Cancel",
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Expanded(
                child: CommonButton(
                  text: "Log Out",
                  padding: EdgeInsets.zero,
                  height: AppSize.displayHeight(context) * 0.05,
                  onPressed: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Get.offAllNamed(RouteConstants.loginScreen);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
