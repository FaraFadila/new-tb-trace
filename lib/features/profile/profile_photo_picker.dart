import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/user_profile_service.dart';

class ProfilePhotoPicker {
  const ProfilePhotoPicker._();

  static Future<bool> show(
    BuildContext context, {
    required UserProfileService profileService,
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7E5DD),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Edit Foto Profil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF171D17),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PhotoSourceTile(
                    icon: Icons.photo_camera_outlined,
                    title: 'Ambil dari Kamera',
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  _PhotoSourceTile(
                    icon: Icons.photo_library_outlined,
                    title: 'Ambil dari Galeri',
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ),
          ),
    );

    if (source == null) return false;

    try {
      final pickedImage = await ImagePicker().pickImage(
        source: source,
        maxWidth: 900,
        maxHeight: 900,
        imageQuality: 75,
      );

      if (pickedImage == null) return false;

      final bytes = await pickedImage.readAsBytes();
      await profileService.updateProfilePhoto(bytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diperbarui.')),
        );
      }

      return true;
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memilih foto. Periksa izin kamera/galeri.'),
          ),
        );
      }

      return false;
    }
  }
}

class _PhotoSourceTile extends StatelessWidget {
  const _PhotoSourceTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF006D37).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF006D37)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF171D17),
        ),
      ),
      onTap: onTap,
    );
  }
}
