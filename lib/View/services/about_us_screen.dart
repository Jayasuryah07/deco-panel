import 'package:deco_flutter_app/Controller/feedback_controller.dart';
import 'package:deco_flutter_app/Util/Constant/app_images.dart';
import 'package:deco_flutter_app/Util/Constant/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Util/Constant/app_colors.dart';

class AboutUsScreen extends GetView<FeedbackController> {
  const AboutUsScreen({super.key});

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
          "About Us",
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
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              AppImages.logo,
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            /* Container(
              height: AppSize.displayHeight(context) * 0.14,
              // Height of the container
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.aboutUsBg),
                  fit: BoxFit
                      .fill, // Ensures the background covers the container
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.panelImage,
                  fit: BoxFit.cover,
                  // Adjust to fill the available space proportionally
                  width: double.infinity,
                  // Ensures it stretches horizontally
                  height: double.infinity, // Ensures it stretches vertically
                ),
              ),
            ),*/
            Text(
              "Deco Panel",
              textAlign: TextAlign.start,
              style: GoogleFonts.roboto(
                color: AppColors.darkHintColor,
                fontSize: Get.height / 45,
                fontWeight: FontWeight.w500,
              ),
            ),
            /* Text(
              "Tag line here",
              textAlign: TextAlign.start,
              style: GoogleFonts.roboto(
                color: AppColors.hintColor2,
                fontSize: Get.height / 60,
                fontWeight: FontWeight.w400,
              ),
            ),*/
            SizedBox(
              height: AppSize.displayHeight(context) * 0.02,
            ),
            commonAboutUsWidget(
              title: "+91 88671 71060",
              imageIconData: Icons.call_rounded,
              isIcon: true,
              context: context,
              onTap: () {
                _launchURL("tel:+91 88671 71060");
              },
            ),
            commonAboutUsWidget(
              title: "info@decopanel.in",
              imageIconData: Icons.email_outlined,
              isIcon: true,
              context: context,
              onTap: () {
                _launchURL("mailto:info@decopanel.in");
              },
            ),
            commonAboutUsWidget(
              title: "www.decopanel.in",
              imageIconData: Icons.public,
              isIcon: true,
              context: context,
              onTap: () {
                _launchURL("https://decopanel.in/");
              },
            ),
            commonAboutUsWidget(
              title: "Our Address",
              imageIconData: Icons.location_on,
              isIcon: true,
              context: context,
              onTap: () {
                _launchURL("https://maps.app.goo.gl/y4hjLRfs3tAKkgD89");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget commonAboutUsWidget(
      {bool isIcon = false,
      String? title,
      void Function()? onTap,
      dynamic imageIconData,
      BuildContext? context}) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: AppSize.displayHeight(context) * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    !isIcon
                        ? Image.asset(imageIconData)
                        : Icon(
                            imageIconData,
                            color: AppColors.buttonColor,
                            size: AppSize.displayHeight(context) * 0.045,
                          ),
                  ],
                ),
              ),
              SizedBox(
                width: AppSize.displayWidth(context) * 0.04,
              ),
              Expanded(
                flex: 4,
                child: Text(
                  title ?? "",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                    color: AppColors.hintColor2,
                    fontSize: Get.height / 50,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class PeanutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at the left-middle edge
    path.moveTo(0, size.height / 2);

    // Top-left bulge
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.1, // Control point for top-left curve
      size.width / 2, size.height * 0.2, // Endpoint for top-center
    );

    // Top-right bulge
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.1, // Control point for top-right curve
      size.width, size.height / 2, // Endpoint at the right-middle
    );

    // Bottom-right bulge
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.9,
      // Control point for bottom-right curve
      size.width / 2, size.height * 0.8, // Endpoint for bottom-center
    );

    // Bottom-left bulge
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.9,
      // Control point for bottom-left curve
      0, size.height / 2, // Endpoint back to the left-middle
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw 'Could not launch $url';
  }
}
