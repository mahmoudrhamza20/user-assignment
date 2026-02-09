import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_management_app/core/constants/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
        backgroundColor: AppColors.grey200,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.grey200,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.grey200,
        child: const Icon(Icons.error),
      ),
    );
  }
}
