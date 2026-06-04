import 'package:deco_flutter_app/Data/Services/product_api_service.dart';
import 'package:deco_flutter_app/Model/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/bottom_nav_controller.dart';
import '../../../Controller/past_order_controller.dart';
import '../../../Data/Providers/api_constants.dart';
import '../../../Util/Constant/app_colors.dart';
import '../../../Util/Constant/app_images.dart';
import '../../../Util/Constant/app_size.dart';
import '../../../Util/custom/custom_toast.dart';
import '../../../widget/common_button.dart';
import '../../../widget/network_image_widget.dart';
import '../../../widget/quanity_picker.dart';
import '../../../widget/text_form_field_widget.dart';
import 'category_widget.dart';

class CategoryItemScreen extends GetView<BottomNavController> {
  const CategoryItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.color42B,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: AppColors.color42B,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarDividerColor: AppColors.whiteColor,
          ),
          shadowColor: Colors.black.withAlpha(102),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  // Light shadow color
                  blurRadius: 10.0,
                  // Soften the shadow
                  offset: const Offset(0, 4), // Shadow appears below the AppBar
                ),
              ],
            ),
          ),
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
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                    controller.changeIndex(2);
                  },
                  icon: Image.asset(
                    AppImages.cartIcon,
                    height: AppSize.displayHeight(context) * 0.025,
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
                        '${Get.find<PastOrderController>().cartList.length}', // Observed count
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingOnly(right: AppSize.displayWidth(context) * 0.02),
          ],
          title: Text(controller.categoryData.value.productCategory ?? ""),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            controller.productCategoryModel.value.data != null &&
                    controller.productCategoryModel.value.data!.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          // Shadow color with opacity
                          spreadRadius: 2,
                          // Spread of the shadow
                          blurRadius: 6,
                          // Blur radius of the shadow
                          offset: const Offset(
                              0, 4), // Offset for the shadow (bottom only)
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.displayWidth(context) * 0.022,
                    ),
                    width: AppSize.displayWidth(context) * 0.25,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: AppSize.displayHeight(context) * 0.01),
                      itemCount:
                          controller.productCategoryModel.value.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryItemWidget(
                          height: AppSize.displayWidth(context) * 0.17,
                          width: AppSize.displayWidth(context) * 0.17,
                          isSelected: controller.categoryData.value ==
                              controller
                                  .productCategoryModel.value.data![index],
                          title: controller.productCategoryModel.value
                                  .data?[index].productCategory ??
                              "",
                          networkImage:
                              "${ApiConstants.imageBaseUrl}${controller.productCategoryModel.value.data?[index].productCategoryImage ?? ""}",
                          onTap: () {
                            controller.categoryData.value = controller
                                .productCategoryModel.value.data![index];
                            controller.getSubCategoryData(controller
                                    .productCategoryModel.value.data?[index].id
                                    .toString() ??
                                "");
                          },
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: AppSize.displayHeight(context) * 0.01,
                      ),
                    ))
                : const SizedBox(),
            SizedBox(
              width: AppSize.displayWidth(context) * 0.02,
            ),
            Obx(
              () => controller.subCategoryModel.value.data != null &&
                      controller.subCategoryModel.value.data!.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                            top: AppSize.displayHeight(context) * 0.01),
                        shrinkWrap: true,
                        itemCount:
                            controller.subCategoryModel.value.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          debugPrint(
                            "${ApiConstants.imageBaseUrl}${controller.subCategoryModel.value.data?[index].productSubCategoryImage ?? ""}",
                          );
                          return subCategoryItem(
                            isLoading: false.obs,
                            //controller.isLoadingTrue,
                            context: context,
                            title: controller.subCategoryModel.value
                                    .data?[index].productSubCategory ??
                                "",
                            image:
                                "${ApiConstants.imageBaseUrl}${controller.subCategoryModel.value.data?[index].productSubCategoryImage ?? ""}",
                            onTap: () async {
                              // Show loading indicator before fetching data
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                // Prevent dismissing the dialog by tapping outside
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height:
                                          AppSize.displayHeight(context) * 0.1,
                                      width:
                                          AppSize.displayHeight(context) * 0.1,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding,
                                          vertical: defaultPadding),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(defaultRadius / 2),
                                        ),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );

                              // Fetch product data
                              debugPrint(
                                  controller.categoryData.value.id.toString());

                              // Start fetching the data
                              await controller.getProductData(
                                context: context,
                                id: controller.categoryData.value.id
                                        ?.toString() ??
                                    "",
                                subId: controller
                                        .subCategoryModel.value.data?[index].id
                                        ?.toString() ??
                                    "",
                              );

                              // Check if all lists are populated
                              if (controller.brandList.isNotEmpty &&
                                  controller.thicknessList.isNotEmpty &&
                                  controller.sizeList.isNotEmpty &&
                                  controller.productItemList.isNotEmpty) {
                                // Dismiss the loading dialog
                                Get.back();
                                controller.qty.value = 1;

                                // Show the dialog if all lists have data
                                if(!context.mounted) return;
                                _showDialog(context, index);
                              } else {
                                // Dismiss the loading dialog
                                Get.back();

                                // If any list is empty, show a toast and navigate back
                                if(!context.mounted) return;
                                customToast(
                                    context,
                                    'Failed to fetch product data',
                                    ToastType.warning);
                                Get.back();
                              }
                            },
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.6,
                            crossAxisCount: 2,
                            crossAxisSpacing:
                                AppSize.displayWidth(context) * 0.02,
                            mainAxisSpacing:
                                AppSize.displayHeight(context) * 0.015),
                      ),
                    )
                  : Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "No Data Available",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ptSans(
                                color: AppColors.color333,
                                fontSize: Get.height / 45,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget subCategoryItem(
      {BuildContext? context,
      String? image,
      String? title,
      required RxBool isLoading,
      void Function()? onTap}) {
    debugPrint('$image');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25), // Shadow color with opacity
            spreadRadius: 2, // Spread of the shadow
            blurRadius: 6, // Blur radius of the shadow
            offset: const Offset(0, 4), // Offset for the shadow (bottom only)
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultRadius),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppSize.displayHeight(context) * 0.02,
        horizontal: AppSize.displayWidth(context) * 0.02,
      ),
      child: Column(
        children: [
          SizedBox(
            height: AppSize.displayHeight(context) * 0.12,
            child: CommonNetworkImage(
              imageUrl: image ?? "",
              placeholder: 'assets/place_holder.png',
              errorPlaceholder: 'assets/place_holder.png',
              fit: BoxFit.cover,
              fadeInDuration: const Duration(
                  milliseconds: 500), // Optional: Adjust fade duration
            ),
          ),
          SizedBox(
            height: AppSize.displayHeight(context) * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title ?? "Testing one1",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ptSans(
                      fontSize: Get.height * 0.018,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkHintColor),
                ),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: onTap ??
                () {
                  // Add your click action here
                  debugPrint("Container clicked!");
                },
            borderRadius:
                BorderRadius.circular(AppSize.displayWidth(context) * 0.015),
            // Match the container radius
            splashColor: AppColors.buttonColor.withAlpha(51),
            // Ripple effect color
            highlightColor: AppColors.buttonColor.withAlpha(51),
            // Tap highlight
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                            AppSize.displayWidth(context) * 0.015)),
                        border: Border.all(color: AppColors.colorF45),
                        color: AppColors.colorF45.withAlpha(51)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.orderListIcon,
                          height: Get.height * 0.02,
                          color: AppColors.colorF45,
                        ),
                        SizedBox(
                          width: Get.width / 50,
                        ),
                        Text(
                          "Order Now",
                          style: GoogleFonts.ptSans(
                            fontSize: Get.height / 65,
                            fontWeight: FontWeight.w700,
                            color: AppColors.colorF45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: Material(
          color: Colors.transparent,
          child: Obx(
            () => controller.isLoadingTrue.value
                ? Container(
                    height: AppSize.displayHeight(context) * 0.1,
                    width: AppSize.displayHeight(context) * 0.1,
                    margin: const EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding),
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
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(defaultRadius / 2))),
                    width: AppSize.displayWidth(context),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select Product',
                                  style: GoogleFonts.ptSans(
                                      fontSize:
                                          AppSize.displayHeight(context) * 0.02,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.color333),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: AppColors.color333),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                            _buildDropdownField<BrandData>(
                              context,
                              label: "Brand",
                              selectedValue: controller.selectedBrand,
                              onChanged: (p0) async {
                                debugPrint('Brand Selected: ${controller.selectedBrand.value?.productsBrand}');
                                controller.selectedThick.value =
                                    ThicknessData();
                                controller.selectedSize.value = SizeData();
                                controller.thicknessList.clear();
                                controller.sizeList.clear();
                                controller.productItemList.clear();
                                controller.thicknessList.value =
                                    await ProductApiService()
                                        .fetchThicknessApiUrl(
                                  loading: controller.isLoadingThick,
                                  id: controller.categoryData.value.id
                                          ?.toString() ??
                                      "",
                                  subId: controller.subCategoryModel.value
                                          .data?[index].id
                                          ?.toString() ??
                                      "",
                                  brand: controller
                                          .selectedBrand.value?.productsBrand ??
                                      "",
                                );
                              },
                              items: controller.brandList
                                  .toSet()
                                  .map<DropdownMenuItem<BrandData>>(
                                    (BrandData e) =>
                                        DropdownMenuItem<BrandData>(
                                      value: e,
                                      child: Text(e.productsBrand ?? ""),
                                    ),
                                  )
                                  .toList()
                                  .obs,
                            ),
                            SizedBox(
                                height: AppSize.displayHeight(context) * 0.02),
                            controller.thicknessList.isNotEmpty
                                ? _buildDropdownField<ThicknessData>(
                                    context,
                                    label: "Thickness",
                                    selectedValue: controller.selectedThick,
                                    onChanged: (p0) async {
                                      controller.selectedSize.value =
                                          SizeData();
                                      controller.sizeList.clear();
                                      controller.productItemList.clear();
                                      controller.sizeList.value =
                                          await ProductApiService()
                                              .fetchSizeApiUrl(
                                        loading: controller.isLoadingThick,
                                        id: controller.categoryData.value.id
                                                ?.toString() ??
                                            "",
                                        subId: controller.subCategoryModel.value
                                                .data?[index].id
                                                ?.toString() ??
                                            "",
                                        brand: controller.selectedBrand.value
                                                ?.productsBrand ??
                                            "",
                                        thickness: controller.selectedThick
                                                .value?.productsThickness ??
                                            '',
                                        unit: controller.selectedThick.value
                                                ?.productsUnit ??
                                            '',
                                      );
                                    },
                                    items: controller.thicknessList
                                        .toSet()
                                        .map<DropdownMenuItem<ThicknessData>>(
                                          (ThicknessData e) =>
                                              DropdownMenuItem<ThicknessData>(
                                            value: e,
                                            child: Text(
                                                "${e.productsThickness?.toString() ?? ""} ${e.productsUnit?.toString() ?? ""}"),
                                          ),
                                        )
                                        .toList()
                                        .obs,
                                  )
                                : const SizedBox(),
                            SizedBox(
                                height: AppSize.displayHeight(context) * 0.02),
                            controller.sizeList.isNotEmpty
                                ? _buildDropdownField<SizeData>(
                                    context,
                                    label: "Size",
                                    selectedValue: controller.selectedSize,
                                    onChanged: (p0) async {
                                      controller.productItemList.value =
                                          await ProductApiService()
                                              .fetchProductApiUrl(
                                        loading: controller.isLoadingThick,
                                        id: controller.categoryData.value.id
                                                ?.toString() ??
                                            "",
                                        subId: controller.subCategoryModel.value
                                                .data?[index].id
                                                ?.toString() ??
                                            "",
                                        brand: controller.selectedBrand.value
                                                ?.productsBrand ??
                                            "",
                                        thickness: controller.selectedThick
                                                .value?.productsThickness ??
                                            '',
                                        unit: controller.selectedThick.value
                                                ?.productsUnit ??
                                            '',
                                        size1: controller.selectedSize.value
                                                ?.productsSize1
                                                .toString() ??
                                            '',
                                        size2: controller.selectedSize.value
                                                ?.productsSize2
                                                .toString() ??
                                            '',
                                        sizeUnit: controller.selectedSize.value
                                                ?.productsSizeUnit
                                                .toString() ??
                                            "",
                                      );

                                      if (controller.productItemList.isEmpty) {
                                        controller.selectedThick.value =
                                            ThicknessData();
                                        controller.selectedSize.value =
                                            SizeData();
                                        controller.thicknessList.clear();
                                        controller.sizeList.clear();
                                        controller.productItemList.clear();
                                        if(!context.mounted) return;
                                        customToast(
                                            context,
                                            'No Product found for add to cart',
                                            ToastType.warning);
                                        return;
                                      }
                                    },
                                    items: controller.sizeList
                                        .toSet()
                                        .map<DropdownMenuItem<SizeData>>(
                                          (SizeData e) =>
                                              DropdownMenuItem<SizeData>(
                                            value: e,
                                            child: Text(
                                                "${e.productsSize1?.toString() ?? ""}*${e.productsSize2?.toString() ?? ""} ${e.productsSizeUnit?.toString() ?? ""}"),
                                          ),
                                        )
                                        .toList()
                                        .obs,
                                  )
                                : const SizedBox(),
                            SizedBox(
                                height: AppSize.displayHeight(context) * 0.02),
                            QuantityPicker(
                              initialQuantity: controller.qty.value,
                              minQuantity: 1,
                              labelText: "Quantity",
                              onQuantityChanged: (quantity) {
                                controller.qty.value = quantity;
                                debugPrint("Selected quantity: $quantity");
                              },
                            ),
                            SizedBox(
                                height: AppSize.displayHeight(context) * 0.025),
                            /* if (controller.productItemList.isEmpty)
                            Row(
                              children: [
                              Text(
                                "No Product found for add to cart",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ptSans(
                                  fontSize: Get.height / 65,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors
                                      .mainColor, // Change text color when selected
                                ),
                              ),
                            ],
                            ),*/

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CommonButton(
                                    boxShadowColor: Colors.transparent,
                                    enabledColor: AppColors.whiteColor,
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: Get.height / 65,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.colorB5B,
                                    ),
                                    text: "Cancel",
                                    isLoading: controller.isLoadingCCart.value,
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        AppSize.displayWidth(context) * 0.02),
                                Expanded(
                                  child: Obx(() => CommonButton(
                                        text: "ADD TO CART",
                                        isEnabled: controller
                                            .productItemList.isNotEmpty,
                                        isLoading:
                                            controller.isLoadingCCart.value,
                                        onPressed: () async {
                                          await ProductApiService()
                                              .createCartApiUrl(
                                            context: context,
                                            id: controller.productItemList.first
                                                    .productsCatgId
                                                    ?.toString() ??
                                                "",
                                            brand: controller.productItemList
                                                    .first.productsBrand
                                                    ?.toString() ??
                                                "",
                                            loading: controller.isLoadingCCart,
                                            qty:
                                                controller.qty.value.toString(),
                                            size1: controller.productItemList
                                                    .first.productsSize1
                                                    ?.toString() ??
                                                "",
                                            size2: controller.productItemList
                                                    .first.productsSize2
                                                    ?.toString() ??
                                                "",
                                            sizeUnit: controller.productItemList
                                                    .first.productsSizeUnit
                                                    ?.toString() ??
                                                "",
                                            subId: controller.productItemList
                                                    .first.productsSubCatgId
                                                    ?.toString() ??
                                                "",
                                            thickness: controller
                                                    .productItemList
                                                    .first
                                                    .productsThickness
                                                    ?.toString() ??
                                                "",
                                            unit: controller.productItemList
                                                    .first.productsUnit
                                                    ?.toString() ??
                                                "",
                                          )
                                              .whenComplete(
                                            () {
                                              Get.back();
                                              PastOrderController pastOrder =
                                                  Get.find<
                                                      PastOrderController>();
                                              pastOrder.getOrderList();
                                            },
                                          );
                                        },
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: AppSize.displayHeight(context) * 0.01),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ));
      },
    );
  }

  Widget _buildDropdownField<T>(
    BuildContext context, {
    required String label,
    void Function(T?)? onChanged,
    required RxList<DropdownMenuItem<T>> items,
    required Rxn<T> selectedValue, // Allow null
    String hintText = "Select an option",
  }) {
    // Filter out duplicates based on value
    final uniqueItems = <T, DropdownMenuItem<T>>{};
    for (var item in items) {
      if (item.value != null) {
        uniqueItems[item.value as T] = item;
      }
    }

    final finalItems = uniqueItems.values.toList();

    // Ensure the selected value matches exactly one item or is null
    final matchedItems =
        finalItems.where((item) => item.value == selectedValue.value).toList();
    if (matchedItems.length != 1) {
      selectedValue.value = null; // Reset if value is invalid
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.ptSans(
            fontSize: AppSize.displayHeight(context) * 0.017,
            fontWeight: FontWeight.w700,
            color: AppColors.colorB5B,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => CommonDropdownField<T>(
            items: finalItems,
            value: selectedValue.value,
            hintText: hintText,
            onChanged: (T? value) {
              selectedValue.value = value;
              if (onChanged != null) onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
