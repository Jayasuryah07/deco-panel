import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/feedback_controller.dart';
import '../../Util/Constant/app_colors.dart';
import '../../Util/Constant/app_size.dart';

class RewardPoint extends GetView<FeedbackController> {
  const RewardPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withAlpha(102),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.color42B,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.color42B,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: AppColors.whiteColor,
        ),
        flexibleSpace: Container(
            decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25), // Light shadow color
              blurRadius: 10.0, // Soften the shadow
              offset: const Offset(0, 4), // Shadow appears below the AppBar
            ),
          ],
        )),
        leading: Padding(
          padding: EdgeInsets.only(left: Get.width * 0.03),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        leadingWidth: Get.width * 0.1,
        title: Text(
          "Reward Point",
          style: GoogleFonts.roboto(
            color: AppColors.color333,
            fontSize: Get.height / 35,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: AppSize.displayHeight(context) * 0.02,
            horizontal: AppSize.displayWidth(context) * 0.04),
        child: Center(
          child: Text(
            "Coming10 Soon",
            textAlign: TextAlign.start,
            style: GoogleFonts.roboto(
              color: AppColors.buttonColor,
              fontSize: Get.height / 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
