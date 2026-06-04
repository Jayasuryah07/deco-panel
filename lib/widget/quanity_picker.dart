import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Util/Constant/app_colors.dart';
import '../Util/Constant/app_size.dart';

class QuantityPicker extends StatefulWidget {
  final int initialQuantity;
  final int minQuantity;
  final int? maxQuantity;
  final String? labelText;
  final void Function(int)? onQuantityChanged;

  const QuantityPicker({
    super.key,
    this.initialQuantity = 1,
    this.minQuantity = 1,
    this.maxQuantity,
    this.labelText,
    this.onQuantityChanged,
  });

  @override
  QuantityPickerState createState() => QuantityPickerState();
}

class QuantityPickerState extends State<QuantityPicker> {
  late int _currentQuantity;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.initialQuantity;
    _controller.text = '$_currentQuantity';
  }

  void _incrementQuantity() {
    if (widget.maxQuantity == null || _currentQuantity < widget.maxQuantity!) {
      setState(() {
        _currentQuantity++;
        _controller.text = '$_currentQuantity';
      });
      widget.onQuantityChanged?.call(_currentQuantity);
    }
  }

  void _decrementQuantity() {
    if (_currentQuantity > widget.minQuantity) {
      setState(() {
        _currentQuantity--;
        _controller.text = '$_currentQuantity';
      });
      widget.onQuantityChanged?.call(_currentQuantity);
    }
  }

  void _onManualEntry(String value) {
    final int? enteredValue = int.tryParse(value);
    if (enteredValue != null) {
      int validatedValue =
          enteredValue < widget.minQuantity ? widget.minQuantity : enteredValue;

      if (widget.maxQuantity != null && validatedValue > widget.maxQuantity!) {
        validatedValue = widget.maxQuantity!;
      }

      setState(() {
        _currentQuantity = validatedValue;
        _controller.text = '$_currentQuantity';
      });
      widget.onQuantityChanged?.call(_currentQuantity);
    } else {
      // Reset to valid quantity on invalid input
      _controller.text = '$_currentQuantity';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelText!,
              style: GoogleFonts.ptSans(
                fontSize: AppSize.displayHeight(context) * 0.017,
                fontWeight: FontWeight.w700,
                color: AppColors.colorB5B,
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          decoration: BoxDecoration(
            color: AppColors.color2F2,
            borderRadius: BorderRadius.circular(defaultRadius * 1),
            border: Border.all(color: AppColors.colorDDD),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: AppColors.color42B,
                  size: AppSize.displayHeight(context) * 0.02,
                ),
                onPressed: _decrementQuantity,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.ptSans(
                    fontSize: Get.height / 55,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color333,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: _onManualEntry,
                  onChanged: (value) {
                    if (value.isEmpty) return;
                    _onManualEntry(value);
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: AppColors.color42B,
                  size: AppSize.displayHeight(context) * 0.02,
                ),
                onPressed: _incrementQuantity,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
