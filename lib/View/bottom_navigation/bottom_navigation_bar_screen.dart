import 'package:deco_flutter_app/Data/Services/api_service.dart';
import 'package:deco_flutter_app/Util/Constant/app_colors.dart';
import 'package:deco_flutter_app/Util/Constant/app_images.dart';
import 'package:deco_flutter_app/Util/Constant/app_size.dart';
import 'package:deco_flutter_app/View/home/component/drawer_widget.dart';
import 'package:deco_flutter_app/View/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/bottom_nav_controller.dart';
import '../../Controller/past_order_controller.dart';
import '../order_list/order_list_screen.dart';
import '../past_order/past_order_screen.dart';
import '../profile/profile_screen.dart';
import '../quotation/current_quotation_screen.dart';

class AnimatedBottomNavBar extends GetView<BottomNavController> {
  final List<IconData> icons = [
    if (userType == 1) Icons.home_outlined,
    Icons.list_alt_outlined,
    if (userType == 1) Icons.shopping_cart_outlined,
    if (userType != 1) Icons.description_outlined,
    Icons.person_outline,
  ];

  final List<IconData> selectedIcons = [
    if (userType == 1) Icons.home_rounded,
    Icons.list_alt_rounded,
    if (userType == 1) Icons.shopping_cart_rounded,
    if (userType != 1) Icons.description_rounded,
    Icons.person_rounded,
  ];

  final List<String> titles = [
    if (userType == 1) 'Home',
    'Order List',
    if (userType == 1) 'Cart',
    if (userType != 1) 'Current Quotation',
    'Profile',
  ];

  final List<Widget> screens = [
    if (userType == 1) const HomeScreen(),
    const PastOrderScreen(),
    if (userType == 1) const OrderListScreen(),
    if (userType != 1) const CurrentQuotationScreen(),
    const ProfileScreen(),
  ];

  AnimatedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('token: $token');
    debugPrint('User Type: ${userDetails.data?.user?.userTypeId}');
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (controller.selectedIndex.value != 0) {
            controller.drawerKey.currentState?.closeDrawer();
            controller.selectedIndex.value = 0;
            return false;
          }
          if (!controller.canCloseApp()) {
            controller.drawerKey.currentState?.closeDrawer();
            Get.snackbar('Hold On', 'Press back again to exit',
                snackPosition: SnackPosition.BOTTOM);
            return false;
          }
          return true;
        },
        child: Scaffold(
          key: controller.drawerKey,
          drawerEnableOpenDragGesture: true,
          drawer: const DrawerWidget(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppColors.color42B,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: AppColors.color42B,
              systemNavigationBarIconBrightness: Brightness.light,
              systemNavigationBarDividerColor: AppColors.whiteColor,
            ),
            elevation: 0.2,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.black.withAlpha(102),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: controller.selectedIndex.value != 1
                        ? Colors.black.withAlpha(13)
                        : Colors.transparent,
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                controller.drawerKey.currentState?.openDrawer();
              },
            ),
            actions: [
              if (controller.selectedIndex.value != 2 && userType == 1)
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.changeIndex(2);
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        size: AppSize.displayHeight(context) * 0.028,
                        color: AppColors.color333,
                      ),
                    ),
                    Obx(
                      () => Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: AppColors.buttonColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${Get.find<PastOrderController>().cartList.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).paddingOnly(right: AppSize.displayWidth(context) * 0.02),
            ],
            title: Text(
              controller.selectedIndex.value == 0
                  ? "Deco Panel"
                  : titles[controller.selectedIndex.value],
              style: GoogleFonts.roboto(
                color: AppColors.color333,
                fontSize: Get.height / 35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Obx(() => screens[controller.selectedIndex.value]),
          bottomNavigationBar: Obx(
            () => Container(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.displayHeight(context) * 0.005,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10.0,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.buttonColor,
                unselectedItemColor: Colors.grey,
                elevation: 0,
                onTap: controller.changeIndex,
                selectedLabelStyle: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                items: List.generate(userType == 1 ? 4 : 3, (index) {
                  return BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        AnimatedIconWidget(
                          iconData: controller.selectedIndex.value == index
                              ? selectedIcons[index]
                              : icons[index],
                          isSelected: controller.selectedIndex.value == index,
                        ),
                        if (index == 2 && userType == 1)
                          Obx(
                            () => Positioned(
                              right: -7,
                              top: -9,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: controller.selectedIndex.value != index
                                      ? AppColors.color333.withAlpha(153)
                                      : AppColors.buttonColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${Get.find<PastOrderController>().cartList.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: titles[index],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedIconWidget extends StatefulWidget {
  final IconData iconData;
  final bool isSelected;

  const AnimatedIconWidget({
    super.key,
    required this.iconData,
    required this.isSelected,
  });

  @override
  AnimatedIconWidgetState createState() => AnimatedIconWidgetState();
}

class AnimatedIconWidgetState extends State<AnimatedIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _colorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            widget.iconData,
            size: AppSize.displayHeight(context) * 0.03,
            color: widget.isSelected
                ? AppColors.buttonColor
                : Colors.grey.withOpacity(0.7 - (_colorAnimation.value * 0.3)),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}