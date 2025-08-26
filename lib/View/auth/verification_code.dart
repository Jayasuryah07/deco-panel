import 'dart:async';

import 'package:deco_flutter_app/Util/Constant/app_size.dart';
import 'package:deco_flutter_app/View/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../Controller/login_controller.dart';
import '../../Data/Services/api_service.dart';
import '../../Util/Constant/app_colors.dart';
import '../../Util/Constant/app_images.dart';
import '../../Util/custom/custom_toast.dart';
import '../../Util/custom/network_connectivity.dart';
import '../../widget/common_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  LoginController loginController = Get.put(LoginController());

  /// GLOBAL KEY FOR VERIFY OTP
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  // OtpController controller = Get.put(OtpController());
  int backspaceCount = 0;

  // final telephony = Telephony.instance;
  RxBool checkTermsCondition = false.obs;

  /// Resend Timer
  final otp = "".obs;
  RxString verify = ''.obs;
  RxInt resendToken = 0.obs;
  late Timer _timer;
  final start = 30.obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (start.value < 1) {
        timer.cancel();
      } else {
        start.value = start.value - 1;
      }
    });
  }

  //final controller = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    //listenToIncomingSMS(context);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /* void listenToIncomingSMS(BuildContext context) {
    print("Listening to sms.");
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Handle message
          print("sms received : ${message.body}");
          // verify if we are reading the correct sms or not

          if (message.body!.contains("deco-panel.firebaseapp.com")) {
            String otpCode = message.body!.substring(0, 6);
            print("OTP::::::$otpCode");
            setState(
              () {
                otpController.otpController.value.text = otpCode;
              },
            );
          }
        },
        listenInBackground: false);
  }*/

  Future<void> sendOTP() async {
    if (!(await NetworkConnectivity.checkInternet())) {
      Get.snackbar(
        "No Internet",
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM, // Position: TOP or BOTTOM
      );
      return;
    }
    loginController.numberController.value.text =
        Get.arguments != null && Get.arguments["no"] != null
            ? Get.arguments["no"]
            : "";
    debugPrint("Verify number: ${loginController.numberController.value.text}");
    await loginController.auth
        .setSettings(appVerificationDisabledForTesting: true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      forceResendingToken: 4,
      phoneNumber: "+91${loginController.numberController.value.text.trim()}",
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        //     mobileNumberController.isButtonLoading.value =
        // false;
        await loginController.auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) async {
        debugPrint('fError : ${e.code},${e.message}');
        if (e.code == 'invalid-phone-number') {
          // mobileNumberController.isButtonLoading.value =
          // false;
          customToast(context, "The provided phone number is not valid.",
              ToastType.warning);

          debugPrint('The provided phone number is not valid.');
        } else if (e.code == 'too-many-requests') {
          // mobileNumberController.isButtonLoading.value =
          // false;
          customToast(
              context,
              "Sorry, You are many requested\nPlease try again later...",
              ToastType.warning);
        } else if (e.code == 'unknown') {
          // await otpController
          //     .postCheckMobileApi({
          //   "mobile": mobileNumberController
          //       .mobileNumberController
          //       .value
          //       .text
          //       .trim(),
          // });
          // mobileNumberController.isButtonLoading.value =
          // false;
          customToast(
              context,
              "Sorry, Internal error has occurred\nPlease try again later...",
              ToastType.error);
        } else {
          // mobileNumberController.isButtonLoading.value =
          // false;
          customToast(
              context,
              "Sorry, Something want wrong\nPlease try again later...",
              ToastType.warning);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        otpController.resendToken.value = resendToken ?? 0;
        otpController.verify.value = verificationId;
        customToast(context, "OTP Sent Successfully", ToastType.success);
        otpController.start.value = 30;
        otpController.startTimer();
        //listenToIncomingSMS(context);
        // mobileNumberController.isButtonLoading.value =
        // false;
        // Get.to(() => OtpScreen(
        //   // verify: verificationId,
        //   // phoneNumber: controller
        //   //     .mobileNumberController
        //   //     .value
        //   //     .text
        //   //     .trim(),
        // ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //     mobileNumberController.isButtonLoading.value =
        // false;

        // ShowToast.showToast(
        //   "The provided phone number is not valid.",
        //   showSuccess: false,
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
        key: otpFormKey,
        child: Obx(
          () => Container(
            padding: EdgeInsets.only(
                left: Get.width / 25,
                right: Get.width / 25,
                top: Get.height / 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    "Enter Verification \nCode",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ptSans(
                      fontSize: Get.height / 23,
                      fontWeight: FontWeight.w700,
                      color: AppColors.color449,
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 30,
                ),
                Image.asset(
                  AppImages.loginVerify,
                  // Width of each input field
                  height: AppSize.displayHeight(context) * 0.3,
                ),
                SizedBox(
                  height: AppSize.displayHeight(context) * 0.04,
                ),
                Text(
                  "Please enter verification code \nsent to +91 ${Get.arguments != null && Get.arguments["no"] != null ? Get.arguments["no"] : ""}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ptSans(
                    fontSize: Get.height / 50,
                    fontWeight: FontWeight.normal,
                    color: AppColors.colorA1E,
                  ),
                ),
                SizedBox(
                  height: AppSize.displayHeight(context) * 0.05,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 6,
                    controller: otpController.otpController.value,
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter otp";
                      } else if (value.length != 6) {
                        return "Please enter valid otp";
                      }
                      return null;
                    },
                    followingPinTheme: PinTheme(
                      width: AppSize.displayWidth(context) * 0.14,
                      height: AppSize.displayWidth(context) * 0.14,
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.colorADB, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    disabledPinTheme: PinTheme(
                      width: AppSize.displayWidth(context) * 0.14,
                      height: AppSize.displayWidth(context) * 0.14,
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.buttonColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onCompleted: (String verificationCode) {
                      // Close the keyboard by unfocusing
                      FocusScope.of(context).unfocus();

                      // Optionally, handle the OTP submission
                      debugPrint('Entered OTP: $verificationCode');
                    },
                    onChanged: (code) {
                      otpController.isAbleFun();
                      debugPrint('OTP Changed: $code');
                    },
                    focusedPinTheme: PinTheme(
                      width: AppSize.displayWidth(context) * 0.14,
                      height: AppSize.displayWidth(context) * 0.14,
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.buttonColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    defaultPinTheme: PinTheme(
                      width: AppSize.displayWidth(context) * 0.14,
                      height: AppSize.displayWidth(context) * 0.14,
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.buttonColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 1,
                          height: 22,
                          color: AppColors.colorA1E,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSize.displayHeight(context) * 0.06,
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        otpController.start.value == 0
                            ? "Didn't received OTP - "
                            : "Resend OTP in ",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      otpController.start.value != 0
                          ? Text(
                              "00:${otpController.start.value.toString().length == 1 ? "0${otpController.start.value}" : otpController.start.value}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                sendOTP();
                              },
                              child: const Text(
                                "Resend",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.buttonColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppSize.displayHeight(context) * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(
                      () => CommonButton(
                        width: AppSize.displayWidth(context) * 0.5,
                        text: 'Verify the Code',
                        isLoading: otpController.isLoading.value,
                        isEnabled: /*otpController.isAble.value*/ true,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          debugPrint('otpController: ${otpController.verify.value}');
                          if (otpFormKey.currentState!.validate()) {
                            try {
                              if (!(await NetworkConnectivity
                                  .checkInternet())) {
                                Get.snackbar(
                                  "No Internet",
                                  'Please check your internet connection',
                                  snackPosition: SnackPosition
                                      .BOTTOM, // Position: TOP or BOTTOM
                                );
                                return;
                              }
                              otpController.isLoading.value = true;
                              // PhoneAuthCredential credential =
                              //     PhoneAuthProvider.credential(
                              //   verificationId: otpController.verify.value,
                              //   smsCode: otpController.otpController.value.text,
                              // );

                              debugPrint(
                                  "login password::::::::::: ${Get.arguments != null && Get.arguments["password"] != null ? Get.arguments["password"] : ""}");
                              debugPrint(
                                  "login deviceId::::::::::: ${Get.arguments != null && Get.arguments["deviceId"] != null ? Get.arguments["deviceId"] : ""}");
                              // controller.postCheckMobileApi({"mobile": mobileNumberController.mobileNumberController.value.text.trim()});
                              if(!context.mounted) return;
                              await ApiService().loginApi(
                                password: Get.arguments != null &&
                                        Get.arguments["password"] != null
                                    ? Get.arguments["password"]
                                    : "",
                                phone: Get.arguments != null &&
                                        Get.arguments["no"] != null
                                    ? Get.arguments["no"]
                                    : "",
                                context: context,
                                loading: otpController.isLoading,
                                deviceId: Get.arguments != null &&
                                        Get.arguments["deviceId"] != null
                                    ? Get.arguments["deviceId"]
                                    : "",
                              );
                              otpController.otpController.value.clear();
                              otpController.isLoading.value =
                                  false; // Stop the loader in case of an error
                            } on FirebaseAuthException catch (error) {
                              otpController.isLoading.value =
                                  false; // Stop the loader in case of an error

                              if (error.code == 'invalid-verification-code') {
                                if(!context.mounted) return;
                                customToast(
                                  context,
                                  "Invalid OTP",
                                  ToastType.warning,
                                );
                              } else {
                                if(!context.mounted) return;
                                customToast(
                                  context,
                                  "Error: ${"Something went wrong"}",
                                  ToastType.error,
                                );
                              }
                              otpController.isLoading.value =
                                  false; // Stop the loader in case of an error
                            } catch (e) {
                              if(!context.mounted) return;
                              customToast(
                                context,
                                "Error: $e",
                                ToastType.error,
                              );
                              debugPrint("error >>>>>>>>>>>>> $e");
                              otpController.isLoading.value =
                                  false; // Ensure the loader is stopped
                            }
                          }
                          //await ApiService().loginApi(
                          //    phone: Get.arguments != null &&
                          //            Get.arguments["no"] != null
                          //        ? Get.arguments["no"]
                          //        : "",
                          //    context: context,
                          //  password:
                          //  otpController.otpController.value.text,
                          //    loading: otpController.isLoading);
                          //otpController.otpController.value.clear();
                          //otpController.isLoading.value = false;
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
