import 'package:flutter/material.dart';

import '../../core/widgets/app_user_header.dart';
import 'edit_profile_page.dart';

class ProfileSidebar extends StatefulWidget {
  const ProfileSidebar({
    super.key,
    this.editProfileFallbackRoute = '/profile-patient',
  });

  final String editProfileFallbackRoute;

  @override
  State<ProfileSidebar> createState() => _ProfileSidebarState();
}

class _ProfileSidebarState extends State<ProfileSidebar> {
  bool notificationOn = true;
  bool darkModeOn = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,

      backgroundColor: const Color(0xFFF8FCF9),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),

      child: Column(
        children: [
          // =========================
          // HEADER
          // =========================
          Container(
            width: double.infinity,

            padding: const EdgeInsets.only(top: 60, bottom: 32),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: [Color(0xFF006D37), Color(0xFF27AE60)],
              ),

              borderRadius: BorderRadius.only(bottomRight: Radius.circular(32)),
            ),

            child: Column(
              children: [
                // PROFILE IMAGE
                Container(
                  width: 92,
                  height: 92,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: Border.all(color: Colors.white, width: 3),

                    image: const DecorationImage(
                      image: AssetImage("assets/images/profile.png"),

                      fit: BoxFit.cover,
                    ),

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                        color: Colors.black.withOpacity(0.12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // NAME
                CurrentUserNameText(
                  builder:
                      (context, displayName) => Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                ),

                const SizedBox(height: 6),

                // EMAIL
                CurrentUserEmailText(
                  builder:
                      (context, email) => Text(
                        email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE8F8F1),
                        ),
                      ),
                ),

                const SizedBox(height: 18),

                // EDIT PROFILE BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder:
                            (_) => EditProfilePage(
                              fallbackRoute: widget.editProfileFallbackRoute,
                            ),
                      ),
                    );
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(30),

                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ],
                    ),

                    child: const Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Text(
                          "Edit Profile",

                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,

                            color: Color(0xFF171D17),
                          ),
                        ),

                        SizedBox(width: 8),

                        Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: Color(0xFF006D37),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =========================
          // CONTENT
          // =========================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // =========================
                  // HEADLINE
                  // =========================
                  _sectionTitle("Headline"),

                  const SizedBox(height: 14),

                  _locationTile(title: "Lokasi Sekarang", value: "Surabaya"),

                  _locationTile(title: "Zona Rawan", value: "Wonokromo"),

                  const SizedBox(height: 28),

                  // =========================
                  // CONTENT
                  // =========================
                  _sectionTitle("Content"),

                  const SizedBox(height: 14),

                  _menuTile(icon: Icons.favorite_border, title: "Favourite"),

                  _switchTile(
                    icon: Icons.notifications,

                    title: "Notification",

                    value: notificationOn,

                    onChanged: (value) {
                      setState(() {
                        notificationOn = value;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  // =========================
                  // PREFERENCES
                  // =========================
                  _sectionTitle("Preferences"),

                  const SizedBox(height: 14),

                  _menuTile(
                    icon: Icons.language,

                    title: "Language",

                    trailing: "EN",
                  ),

                  _switchTile(
                    icon: Icons.dark_mode_outlined,

                    title: "Dark Mode",

                    value: darkModeOn,

                    onChanged: (value) {
                      setState(() {
                        darkModeOn = value;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // LOGOUT
                  // =========================
                  GestureDetector(
                    onTap: () {},

                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F1),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: Color(0xFFD32F2F)),

                          SizedBox(width: 14),

                          Text(
                            "Log Out",

                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,

                              color: Color(0xFFD32F2F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SECTION TITLE
  // =========================
  Widget _sectionTitle(String text) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        color: const Color(0xFFEFF6EC),

        borderRadius: BorderRadius.circular(10),
      ),

      child: Text(
        text,

        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF53615C),
        ),
      ),
    );
  }

  // =========================
  // LOCATION TILE
  // =========================
  Widget _locationTile({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),

          Text(
            value,

            style: const TextStyle(fontSize: 13, color: Color(0xFF53615C)),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Color(0xFF006D37),
          ),
        ],
      ),
    );
  }

  // =========================
  // MENU TILE
  // =========================
  Widget _menuTile({
    required IconData icon,
    required String title,
    String? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),

      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF006D37)),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),

          if (trailing != null)
            Text(
              trailing,

              style: const TextStyle(fontSize: 13, color: Color(0xFF53615C)),
            ),
        ],
      ),
    );
  }

  // =========================
  // SWITCH TILE
  // =========================
  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),

      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF006D37)),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),

          Switch(
            value: value,

            activeColor: Colors.white,

            activeTrackColor: const Color(0xFF27AE60),

            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
