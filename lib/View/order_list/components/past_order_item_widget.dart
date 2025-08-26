import 'package:deco_flutter_app/Util/Constant/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/past_order_controller.dart';
import '../../../Util/Constant/app_colors.dart';
import '../../../Util/Constant/app_size.dart';
import '../../../widget/network_image_widget.dart';

enum OrderType { orderList, pastOrder }

class PastOrderItem extends GetView<PastOrderController> {
  final String? title;
  final String? networkImage;
  final String? subTitle;
  final String? size;
  final String? qtyStr;
  final String? thickness;
  final bool isEditable;
  final String? brand;
  final Widget? orderWidget;
  final Widget? statusWidget;
  final int? initialValue;
  final int? initialQuo;
  final Function(int)? onQtyValueChanged;
  final Function(int)? onQty2ValueChanged;
  final RxBool? value;
  final void Function(bool?)? onChanged;
  final void Function()? onDeletePressed;
  final void Function()? onTap;

  const PastOrderItem(
      {super.key,
      this.title,
      this.onTap,
      this.isEditable = false,
      this.initialValue,
      this.initialQuo,
      this.qtyStr,
      this.onQtyValueChanged,
      this.onQty2ValueChanged,
      this.orderWidget,
      this.subTitle,
      this.statusWidget,
      this.size,
      this.thickness,
      this.brand,
      this.onDeletePressed,
      this.networkImage,
      this.value,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppColors.bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*if (orderWidget == null)
                  Obx(
                    () => CheckboxTheme(
                      data: CheckboxThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        side: const BorderSide(
                          color: Colors.grey,
                          // Border color for both active and inactive
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Checkbox(
                        value: value?.value ?? true,
                        onChanged: onChanged,
                        fillColor:
                            const MaterialStatePropertyAll(Colors.transparent),

                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.grey, // Border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        side: const BorderSide(
                          color: Colors.grey, // Border color
                          width: 2.0, // Border width
                        ),
                        checkColor: AppColors.colorF45,
                        // Check icon color
                        activeColor:
                            AppColors.colorF45, // Background color when checked
                      ),
                    ),
                  ),*/
                if (networkImage != "")
                  SizedBox(
                    height: AppSize.displayHeight(context) * 0.11,
                    width: AppSize.displayHeight(context) * 0.11,
                    child: CommonNetworkImage(
                      imageUrl: networkImage ?? "",
                      placeholder: 'assets/place_holder.png',
                      errorPlaceholder: 'assets/place_holder.png',
                      fit: BoxFit.fill,
                      fadeInDuration: const Duration(milliseconds: 500),
                    ),
                  ),
                if (networkImage != "")
                  SizedBox(
                    width: AppSize.displayWidth(context) * 0.035,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              title ?? "",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.ptSans(
                                fontSize: Get.height / 55,
                                fontWeight: FontWeight.w700,
                                color: AppColors.color333,
                              ),
                            ),
                          ),
                        ],
                      ),
                      orderWidget ??
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonTextWidget(
                                context: context,
                                title: "Size",
                                subTitle: size,
                              ),
                              commonTextWidget(
                                context: context,
                                title: "Brand",
                                subTitle: brand,
                              ),
                              commonTextWidget(
                                context: context,
                                title: "Thickness",
                                subTitle: thickness,
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
                if (statusWidget != null) statusWidget!
              ],
            ),
            if (statusWidget == null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    qtyStr ?? "Rate : ",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.ptSans(
                      fontSize: Get.height / 55,
                      fontWeight: FontWeight.w700,
                      color: AppColors.color333,
                    ),
                  ),
                  PlusMinusContainer(
                    initialValue: initialValue ?? 1,
                    isEditable: isEditable,
                    onValueChanged: onQtyValueChanged ?? (p0) {},
                  ),
                  if (initialQuo != null)
                    Text(
                      "Qty : ",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.ptSans(
                        fontSize: Get.height / 55,
                        fontWeight: FontWeight.w700,
                        color: AppColors.color333,
                      ),
                    ).paddingOnly(left: AppSize.displayWidth(context) * 0.04),
                  if (initialQuo != null)
                    PlusMinusContainer(
                      initialValue: initialQuo!,
                      isEditable: true,
                      onValueChanged: onQty2ValueChanged ?? (p0) {},
                    ) /*.paddingOnly(left: AppSize.displayWidth(context) * 0.04)*/
                  else if (initialQuo == null) ...[
                    const Spacer(),
                    IconButton(
                      onPressed: onDeletePressed ?? () {},
                      icon: Image.asset(
                        AppImages.deleteIcon,
                        height: AppSize.displayHeight(context) * 0.022,
                      ),
                    ),
                  ]
                ],
              ).paddingOnly(top: AppSize.displayHeight(context) * 0.005),
            const Divider(
              color: AppColors.colorDDD,
            )
          ],
        ),
      ),
    );
  }
}

class PlusMinusContainer extends StatefulWidget {
  final int initialValue;
  final bool isEditable;
  final Function(int) onValueChanged;

  const PlusMinusContainer({
    super.key,
    this.initialValue = 1,
    this.isEditable = false,
    required this.onValueChanged,
  });

  @override
  PlusMinusContainerState createState() => PlusMinusContainerState();
}

class PlusMinusContainerState extends State<PlusMinusContainer> {
  late int _currentValue;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _currentValue.toString());
  }

  void _increment() {
    setState(() {
      _currentValue++;
      _controller.text = _currentValue.toString();
    });
    widget.onValueChanged(_currentValue);
  }

  void _decrement() {
    if (_currentValue > 1) {
      setState(() {
        _currentValue--;
        _controller.text = _currentValue.toString();
      });
      widget.onValueChanged(_currentValue);
    }
  }

  void _onManualChange(String value) {
    final int? newValue = int.tryParse(value);
    if (newValue != null && newValue >= 1) {
      setState(() {
        _currentValue = newValue;
      });
      widget.onValueChanged(_currentValue);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding / 2,
        vertical: AppSize.displayHeight(context) * 0.005,
      ),
      decoration: BoxDecoration(
        color: AppColors.color6F6,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(defaultRadius * 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: _currentValue > 1 ? _decrement : null,
            child: Icon(
              Icons.remove,
              color: _currentValue > 1 ? AppColors.textBlack : Colors.grey,
              size: AppSize.displayHeight(context) * 0.03,
            ),
          ),
          SizedBox(width: AppSize.displayWidth(context) * 0.04),
          widget.isEditable
              ? SizedBox(
                  width: AppSize.displayWidth(context) * 0.08,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: _onManualChange,
                    style: GoogleFonts.ptSans(
                      fontSize: Get.height / 50,
                      fontWeight: FontWeight.w700,
                      color: AppColors.color333,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  ),
                )
              : Text(
                  _currentValue.toString(),
                  style: GoogleFonts.ptSans(
                    fontSize: Get.height / 50,
                    fontWeight: FontWeight.w700,
                    color: AppColors.color333,
                  ),
                ),
          SizedBox(width: AppSize.displayWidth(context) * 0.04),
          InkWell(
            onTap: _increment,
            child: Icon(
              Icons.add,
              color: AppColors.textBlack,
              size: AppSize.displayHeight(context) * 0.03,
            ),
          ),
        ],
      ),
    );
  }
}

Widget statusWidget({
  required BuildContext context,
  required String statusTitle,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: AppSize.displayWidth(context) * 0.05,
        vertical: AppSize.displayHeight(context) * 0.002),
    decoration: const BoxDecoration(
        color: AppColors.colorC1F,
        borderRadius: BorderRadius.all(Radius.circular(defaultRadius / 5))),
    child: Text(
      statusTitle,
      style: GoogleFonts.ptSans(
        fontSize: Get.height / 65,
        fontWeight: FontWeight.w500,
        color: AppColors.whiteColor,
      ),
    ),
  );
}

Widget pastOrderWidget(
    {BuildContext? context,
    String? orderDate,
    String? orderNumber,
    String? royaltyPoint}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: AppSize.displayHeight(context) * 0.002,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Number: ",
            style: GoogleFonts.ptSans(
              fontSize: Get.height / 65,
              fontWeight: FontWeight.w400,
              color: AppColors.color333,
            ),
          ),
          Text(
            orderNumber ?? "",
            style: GoogleFonts.ptSans(
              fontSize: Get.height / 65,
              fontWeight: FontWeight.w600,
              color: AppColors.color333,
            ),
          ),
        ],
      ),
      Text(
        "Order Date: ${formatDateFromString(orderDate ?? "")}",
        style: GoogleFonts.ptSans(
          fontSize: Get.height / 65,
          fontWeight: FontWeight.w400,
          color: AppColors.color333,
        ),
      ),
      SizedBox(
        height: Get.height * 0.01,
      ),
      Row(
        children: [
          Container(
            height: AppSize.displayHeight(context) * 0.033,
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.displayWidth(context) * 0.04),
            decoration: BoxDecoration(
              color: AppColors.color419.withAlpha(51),
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultRadius / 5),
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  AppImages.tokenIcon,
                  height: AppSize.displayHeight(context) * 0.022,
                ).paddingOnly(bottom: AppSize.displayHeight(context) * 0.004),
                SizedBox(
                  width: AppSize.displayWidth(context) * 0.02,
                ),
                Text(
                  "Royalty Points",
                  style: GoogleFonts.ptSans(
                    fontSize: Get.height / 65,
                    fontWeight: FontWeight.w400,
                    color: AppColors.color333,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget commonTextWidget(
    {String? title, String? subTitle, BuildContext? context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        "${title ?? ""} : ",
        textAlign: TextAlign.start,
        style: GoogleFonts.roboto(
          color: AppColors.hintColor2,
          fontSize: Get.height / 65,
          fontWeight: FontWeight.w400,
        ),
      ),
      Expanded(
        flex: 8,
        child: Text(
          subTitle ?? "",
          textAlign: TextAlign.start,
          style: GoogleFonts.roboto(
            color: AppColors.color333,
            fontSize: Get.height / 65,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

String formatDateFromString(String inputDate) {
  // Parse the input date string into a DateTime object
  try {
    DateTime date = DateTime.parse(inputDate);

    // List of month abbreviations
    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    // Format the date
    String formattedDate = "${date.day} ${months[date.month - 1]} ${date.year}";
    return formattedDate;
  } catch (e) {
    return "";
  }
}
