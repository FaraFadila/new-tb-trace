import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/user_profile_service.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    this.borderColor = const Color(0xFF006D37),
    this.borderWidth = 3,
    this.assetImage,
    this.iconColor = const Color(0xFF64748B),
    this.iconSize,
    this.onTap,
    this.boxShadow,
  });

  final double size;
  final Color borderColor;
  final double borderWidth;
  final String? assetImage;
  final Color iconColor;
  final double? iconSize;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final profileService = UserProfileService();

    return ValueListenableBuilder<int>(
      valueListenable: profileService.profilePhotoChanges,
      builder: (context, _, child) {
        return FutureBuilder<Uint8List?>(
          future: profileService.currentProfilePhotoBytes(),
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            final ImageProvider? avatarImage =
                bytes != null
                    ? MemoryImage(bytes)
                    : assetImage == null
                    ? null
                    : AssetImage(assetImage!);

            Widget avatar = Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2F3),
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: borderWidth),
                image:
                    avatarImage == null
                        ? null
                        : DecorationImage(
                          image: avatarImage,
                          fit: BoxFit.cover,
                        ),
                boxShadow: boxShadow,
              ),
              child:
                  avatarImage == null
                      ? Icon(
                        Icons.person,
                        size: iconSize ?? size * 0.52,
                        color: iconColor,
                      )
                      : null,
            );

            if (onTap == null) return avatar;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: avatar,
            );
          },
        );
      },
    );
  }
}
