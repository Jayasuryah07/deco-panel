import 'package:deco_flutter_app/Util/Constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonNetworkImage extends StatelessWidget {
  final String? imageUrl; // The URL of the network image
  final String placeholder; // Path to the placeholder asset
  final String errorPlaceholder; // Path to the error fallback asset
  final BoxFit fit; // BoxFit for the image
  final Duration fadeInDuration; // Duration for fade-in animation

  const CommonNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholder = 'assets/place_holder.png',
    this.errorPlaceholder = 'assets/place_holder.png',
    this.fit = BoxFit.cover,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: const NetworkImage(""),
      // Placeholder image
      image: NetworkImage(imageUrl ?? ""),
      // Network image
      fit: fit,
      fadeInDuration: fadeInDuration,
      // Smooth fade-in effect
      placeholderFit: fit,
      placeholderErrorBuilder: (context, error, stackTrace) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        );
      },

      imageErrorBuilder: (context, error, stackTrace) {
        // Handle error with fallback image
        return Container(
          width: Get.height * 0.2,
          height: Get.height * 0.2,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(placeholder),
              ),
              border: Border.all(color: AppColors.buttonColor),
              shape: BoxShape.circle),
        );
      },
    );
  }
}
