import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Controller/bottom_nav_controller.dart';
import '../../../Controller/profile_controller.dart';
import '../../../Data/Services/api_service.dart';
import '../../../RoutesManagment/routes.dart';
import '../../../Util/Constant/app_colors.dart';
import '../../../Util/Constant/app_images.dart';
import '../../../Util/Constant/app_size.dart';
import '../../../widget/common_button.dart';
import '../home_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<DrawerItem> drawerItem = [];

  // Static values
  static const String appVersion = "10.0.0";
  static const String lastUpdatedDate = "04/06/2026";
 

  @override
  void initState() {
    super.initState();
    // Initialize drawer items based on userType
    if (userType == 1) {
      drawerItem = [
        DrawerItem(title: "Home", icon: Icons.home_outlined, selectedIcon: Icons.home_rounded),
        DrawerItem(title: "Profile", icon: Icons.person_outline, selectedIcon: Icons.person_rounded),
        DrawerItem(title: "Order List", icon: Icons.list_alt_outlined, selectedIcon: Icons.list_alt_rounded),
        DrawerItem(title: "Feedback", icon: Icons.feedback_outlined, selectedIcon: Icons.feedback_rounded),
        DrawerItem(title: "About Us", icon: Icons.info_outline, selectedIcon: Icons.info_rounded),
        DrawerItem(title: "Logout", icon: Icons.logout_outlined, selectedIcon: Icons.logout_rounded),
      ];
    } else {
      drawerItem = [
        DrawerItem(title: "Profile", icon: Icons.person_outline, selectedIcon: Icons.person_rounded),
        DrawerItem(title: "Order List", icon: Icons.list_alt_outlined, selectedIcon: Icons.list_alt_rounded),
        DrawerItem(title: "Feedback", icon: Icons.feedback_outlined, selectedIcon: Icons.feedback_rounded),
        DrawerItem(title: "About Us", icon: Icons.info_outline, selectedIcon: Icons.info_rounded),
        DrawerItem(title: "Logout", icon: Icons.logout_outlined, selectedIcon: Icons.logout_rounded),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgColor,
      child: Container(
        color: AppColors.bgColor,
        child: Column(
          children: [
            // Expanded ListView for menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // User Profile Header
                  Obx(
                    () => Container(
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
                          Container(
                            height: AppSize.displayWidth(context) * 0.28,
                            width: AppSize.displayWidth(context) * 0.28,
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
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: const BoxDecoration(
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
                          SizedBox(
                            height: AppSize.displayHeight(context) * 0.02,
                          ),
                          Text(
                            Get.find<ProfileController>()
                                    .useDataModel
                                    .value
                                    .data
                                    ?.fullName ??
                                "Guest User",
                            style: GoogleFonts.poppins(
                              color: AppColors.darkHintColor,
                              fontSize: Get.height / 45,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              Get.find<ProfileController>()
                                      .useDataModel
                                      .value
                                      .data
                                      ?.email ??
                                  "user@example.com",
                              style: GoogleFonts.poppins(
                                color: AppColors.buttonColor,
                                fontSize: Get.height / 65,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppSize.displayHeight(context) * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.buttonColor,
                    thickness: 1,
                    height: 1,
                  ),
                  // Drawer Menu Items
                  ...List.generate(
                    drawerItem.length,
                    (index) => ListTile(
                      leading: Icon(
                        drawerItem[index].icon,
                        color: AppColors.buttonColor,
                        size: AppSize.displayHeight(context) * 0.027,
                      ),
                      title: Text(
                        drawerItem[index].title,
                        style: GoogleFonts.poppins(
                          fontSize: Get.height / 55,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkHintColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.buttonColor.withOpacity(0.5),
                        size: AppSize.displayHeight(context) * 0.02,
                      ),
                      onTap: () async {
                        var con = Get.find<BottomNavController>();
                        if (userType == 1) {
                          switch (index) {
                            case 0: // Home
                              con.drawerKey.currentState?.closeDrawer();
                              con.changeIndex(0);
                              break;
                            case 1: // Profile
                              con.drawerKey.currentState?.closeDrawer();
                              con.changeIndex(3);
                              break;
                            case 2: // Order List
                              con.drawerKey.currentState?.closeDrawer();
                              con.changeIndex(1);
                              break;
                            case 3: // Feedback
                              Get.toNamed(RouteConstants.feedBackScreen);
                              break;
                            case 4: // About Us
                              Get.toNamed(RouteConstants.aboutUsScreen);
                              break;
                            case 5: // Logout
                              showLogoutDialog(context);
                              break;
                            default:
                          }
                        } else {
                          switch (index) {
                            case 0: // Profile
                              con.drawerKey.currentState?.closeDrawer();
                              con.changeIndex(2);
                              break;
                            case 1: // Order List
                              con.drawerKey.currentState?.closeDrawer();
                              con.changeIndex(0);
                              break;
                            case 2: // Feedback
                              Get.toNamed(RouteConstants.feedBackScreen);
                              break;
                            case 3: // About Us
                              Get.toNamed(RouteConstants.aboutUsScreen);
                              break;
                            case 4: // Logout
                              showLogoutDialog(context);
                              break;
                            default:
                          }
                        }
                      },
                    ),
                  ),
                  // Add extra space before footer
                  SizedBox(
                    height: AppSize.displayHeight(context) * 0.02,
                  ),
                ],
              ),
            ),
            // Footer Section with Version and Date - Completely at the bottom
            Container(
              margin: EdgeInsets.only(
                bottom: AppSize.displayHeight(context) * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(
                    color: AppColors.buttonColor,
                    thickness: 0.5,
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: AppSize.displayHeight(context) * 0.02,
                  ),
                  // Version Info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: AppSize.displayHeight(context) * 0.018,
                              color: AppColors.buttonColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Version $appVersion",
                              style: GoogleFonts.poppins(
                                fontSize: Get.height / 65,
                                fontWeight: FontWeight.w600,
                                color: AppColors.buttonColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: AppSize.displayHeight(context) * 0.016,
                              color: AppColors.hintColor2,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Last Updated: $lastUpdatedDate",
                              style: GoogleFonts.poppins(
                                fontSize: Get.height / 70,
                                fontWeight: FontWeight.w400,
                                color: AppColors.hintColor2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppSize.displayHeight(context) * 0.02,
                  ),
                  // Copyright Text
                  
                  SizedBox(
                    height: AppSize.displayHeight(context) * 0.02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: AppColors.buttonColor,
                size: AppSize.displayHeight(context) * 0.03,
              ),
              const SizedBox(width: 10),
              Text(
                "Log Out",
                style: GoogleFonts.poppins(
                  fontSize: Get.height / 45,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color333,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: GoogleFonts.poppins(
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
}

// Drawer Item Model Class
class DrawerItem {
  final String title;
  final IconData icon;
  final IconData selectedIcon;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.selectedIcon,
  });
}