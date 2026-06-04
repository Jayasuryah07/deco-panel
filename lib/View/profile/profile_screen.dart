import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/profile_controller.dart';
import '../../Util/Constant/app_colors.dart';
import '../../Util/Constant/app_images.dart';
import '../../Util/Constant/app_size.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: Container(
                  height: AppSize.displayHeight(context) * 0.1,
                  width: AppSize.displayHeight(context) * 0.1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                    vertical: defaultPadding,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(defaultRadius / 2),
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                ),
              )
            : controller.useDataModel.value.data != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header Gradient Background
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.buttonColor.withOpacity(0.1),
                                Colors.white,
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: AppSize.displayHeight(context) * 0.05,
                              ),
                              // Profile Image Section
                              Center(
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: AppSize.displayWidth(context) * 0.4,
                                      width: AppSize.displayWidth(context) * 0.4,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.buttonColor,
                                            AppColors.buttonColor.withOpacity(0.7),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.buttonColor.withOpacity(0.3),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(defaultRadius * 50),
                                            ),
                                            child: Image.asset(
                                              AppImages.panelImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Edit Icon on Image
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.buttonColor,
                                            AppColors.buttonColor.withOpacity(0.8),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        size: AppSize.displayHeight(context) * 0.025,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: AppSize.displayHeight(context) * 0.02,
                              ),
                              // User Name
                              Text(
                                controller.useDataModel.value.data?.fullName ?? "User",
                                style: GoogleFonts.poppins(
                                  fontSize: Get.height / 35,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkHintColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // User Role/Member Since
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                               
                              
                              ),
                              SizedBox(
                                height: AppSize.displayHeight(context) * 0.03,
                              ),
                            ],
                          ),
                        ),
                        
                        // Stats Cards Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.displayWidth(context) * 0.04,
                            vertical: AppSize.displayHeight(context) * 0.02,
                          ),
                          
                        ),
                        
                        // User Details Section Title
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.displayWidth(context) * 0.04,
                            vertical: AppSize.displayHeight(context) * 0.01,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.buttonColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Personal Information",
                                style: GoogleFonts.poppins(
                                  fontSize: Get.height / 45,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkHintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // User Details Card
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: AppSize.displayWidth(context) * 0.04,
                            vertical: AppSize.displayHeight(context) * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              commonProfileTextWidget(
                                title: "Mobile Number",
                                subTitle: controller.useDataModel.value.data?.mobile ?? "",
                                icon: Icons.phone_android_outlined,
                                context: context,
                              ),
                              commonProfileTextWidget(
                                title: "Email Address",
                                subTitle: controller.useDataModel.value.data?.email ?? "",
                                icon: Icons.email_outlined,
                                context: context,
                              ),
                              commonProfileTextWidget(
                                title: "Location",
                                subTitle: controller.useDataModel.value.data?.state ?? "",
                                icon: Icons.location_on_outlined,
                                context: context,
                              ),
                              commonProfileTextWidget(
                                title: "Address",
                                subTitle: controller.useDataModel.value.data?.address ?? "",
                                icon: Icons.home_outlined,
                                context: context,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(
                          height: AppSize.displayHeight(context) * 0.02,
                        ),
                        
                        // Delete Account Button
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: AppSize.displayWidth(context) * 0.04,
                            vertical: AppSize.displayHeight(context) * 0.01,
                          ),
                          child: ElevatedButton(
                            onPressed: () => deleteDialog(context, Get.height, Get.width),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              minimumSize: Size(
                                AppSize.displayWidth(context),
                                AppSize.displayHeight(context) * 0.065,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: Colors.red.withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  size: AppSize.displayHeight(context) * 0.025,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: AppSize.displayWidth(context) * 0.02,
                                ),
                                Text(
                                  "Delete Account",
                                  style: GoogleFonts.poppins(
                                    fontSize: Get.height / 45,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(
                          height: AppSize.displayHeight(context) * 0.03,
                        ),
                        
                        // Version Info
                        Column(
                          children: [
                            Divider(
                              color: AppColors.hintColor2.withOpacity(0.3),
                              thickness: 0.5,
                              indent: 50,
                              endIndent: 50,
                            ),
                            SizedBox(
                              height: AppSize.displayHeight(context) * 0.02,
                            ),
                            Text(
                              "Version 10.0.0",
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor2,
                                fontSize: Get.height / 60,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Released on June 4, 2026",
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor2.withOpacity(0.7),
                                fontSize: Get.height / 65,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(
                          height: AppSize.displayHeight(context) * 0.03,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_off_outlined,
                            size: AppSize.displayHeight(context) * 0.08,
                            color: AppColors.buttonColor,
                          ),
                        ),
                        SizedBox(
                          height: AppSize.displayHeight(context) * 0.02,
                        ),
                        Text(
                          "No Data Available",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.color333,
                            fontSize: Get.height / 40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please login to view your profile",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.hintColor2,
                            fontSize: Get.height / 55,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.displayHeight(context) * 0.015,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.buttonColor,
              size: AppSize.displayHeight(context) * 0.03,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: Get.height / 40,
                fontWeight: FontWeight.w700,
                color: AppColors.darkHintColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: Get.height / 65,
                fontWeight: FontWeight.w500,
                color: AppColors.hintColor2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commonProfileTextWidget({
    String? title,
    String? subTitle,
    IconData? icon,
    BuildContext? context,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 1.5,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.buttonColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon ?? Icons.info_outline,
                  size: AppSize.displayHeight(context) * 0.025,
                  color: AppColors.buttonColor,
                ),
              ),
              SizedBox(
                width: AppSize.displayWidth(context) * 0.04,
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title ?? "",
                  style: GoogleFonts.poppins(
                    color: AppColors.hintColor2,
                    fontSize: Get.height / 55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  subTitle ?? "Not provided",
                  style: GoogleFonts.poppins(
                    color: AppColors.darkHintColor,
                    fontSize: Get.height / 55,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          if (!isLast)
            Divider(
              color: AppColors.hintColor2.withOpacity(0.2),
              height: 1,
              thickness: 0.5,
            ),
        ],
      ),
    );
  }
}

// Delete Dialog Function
Future<void> deleteDialog(BuildContext context, double height, double width) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Warning Icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red.shade100,
                        Colors.red.shade50,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: height * 0.07,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                "Delete Account?",
                style: GoogleFonts.poppins(
                  fontSize: height / 35,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkHintColor,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: height * 0.015),
              Text(
                "This action cannot be undone. All your data, including orders, wishlist, and personal information, will be permanently deleted.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: height / 60,
                  fontWeight: FontWeight.w400,
                  color: AppColors.hintColor2,
                  height: 1.4,
                ),
              ),
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.hintColor2,
                        padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding / 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: AppColors.hintColor2.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: height / 55,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Call your controller's delete method
                        // Get.find<ProfileController>().deleteAccount();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding / 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        "Delete",
                        style: GoogleFonts.poppins(
                          fontSize: height / 55,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}