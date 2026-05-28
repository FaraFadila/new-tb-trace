import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/user_profile_service.dart';

class ProfileAvatar extends StatefulWidget {
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
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  final UserProfileService _profileService = UserProfileService();
  Uint8List? _photoBytes;
  late Future<Uint8List?> _photoFuture;

  @override
  void initState() {
    super.initState();
    _photoFuture = _loadPhoto();
    _profileService.profilePhotoChanges.addListener(_reloadPhoto);
  }

  @override
  void dispose() {
    _profileService.profilePhotoChanges.removeListener(_reloadPhoto);
    super.dispose();
  }

  Future<Uint8List?> _loadPhoto() async {
    final bytes = await _profileService.currentProfilePhotoBytes();
    if (mounted) {
      _photoBytes = bytes;
    }
    return bytes;
  }

  void _reloadPhoto() {
    if (!mounted) return;

    setState(() {
      _photoFuture = _loadPhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _photoFuture,
      builder: (context, snapshot) {
        final bytes =
            snapshot.connectionState == ConnectionState.done
                ? snapshot.data
                : _photoBytes;
        final ImageProvider? avatarImage =
            bytes != null
                ? MemoryImage(bytes)
                : widget.assetImage == null
                ? null
                : AssetImage(widget.assetImage!);

        Widget avatar = Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2F3),
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
            image:
                avatarImage == null
                    ? null
                    : DecorationImage(image: avatarImage, fit: BoxFit.cover),
            boxShadow: widget.boxShadow,
          ),
          child:
              avatarImage == null
                  ? Icon(
                    Icons.person,
                    size: widget.iconSize ?? widget.size * 0.52,
                    color: widget.iconColor,
                  )
                  : null,
        );

        if (widget.onTap == null) return avatar;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: avatar,
        );
      },
    );
  }
}
