import 'package:flutter/material.dart';

import 'package:tb_trace/features/profile/edit_profile_page.dart';

class ProfileSidebar extends StatefulWidget {
  const ProfileSidebar({super.key});

  @override
  State<ProfileSidebar> createState() =>
      _ProfileSidebarState();
}

class _ProfileSidebarState
    extends State<ProfileSidebar> {
  bool notificationOn = true;
  bool darkModeOn = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(50),
        ),
      ),

      child: Column(
        children: [
          // =========================
          // HEADER
          // =========================
          Container(
            width: double.infinity,

            padding: const EdgeInsets.only(
              top: 60,
              bottom: 30,
            ),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF006D37),
                  Color(0xFF00D36A),
                ],
              ),

              borderRadius:
                  BorderRadius.only(
                bottomRight:
                    Radius.circular(50),
              ),
            ),

            child: Column(
              children: [
                // PROFILE IMAGE
                Container(
                  width: 88,
                  height: 88,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),

                    image:
                        const DecorationImage(
                      image: AssetImage(
                        "assets/images/profile.png",
                      ),

                      fit: BoxFit.cover,
                    ),

                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color:
                            Color.fromRGBO(
                          0,
                          0,
                          0,
                          0.1,
                        ),

                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  "Larry Davis",

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w600,

                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 14),

                // =========================
                // EDIT PROFILE BUTTON
                // =========================
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            const EditProfilePage(),
                      ),
                    );
                  },

                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: const Row(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [
                        Text(
                          "Edit Profile",

                          style: TextStyle(
                            fontSize: 12,

                            fontWeight:
                                FontWeight
                                    .w500,

                            color:
                                Colors.black,
                          ),
                        ),

                        SizedBox(width: 6),

                        Icon(
                          Icons
                              .arrow_forward_ios,
                          size: 12,
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
              padding:
                  const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  // =========================
                  // HEADLINE
                  // =========================
                  _sectionTitle(
                    "Headline",
                  ),

                  const SizedBox(height: 14),

                  _locationTile(
                    title:
                        "Lokasi Sekarang",

                    value: "Surabaya",
                  ),

                  _locationTile(
                    title: "Zona Rawan",
                    value: "Wonokromo",
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // CONTENT
                  // =========================
                  _sectionTitle(
                    "Content",
                  ),

                  const SizedBox(height: 14),

                  _menuTile(
                    icon:
                        Icons.favorite_border,

                    title: "Favourite",
                  ),

                  _switchTile(
                    icon:
                        Icons.notifications,

                    title: "Notification",

                    value: notificationOn,

                    onChanged: (value) {
                      setState(() {
                        notificationOn =
                            value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // PREFERENCES
                  // =========================
                  _sectionTitle(
                    "Preferences",
                  ),

                  const SizedBox(height: 14),

                  _menuTile(
                    icon: Icons.language,

                    title: "Language",

                    trailing: "In",
                  ),

                  _switchTile(
                    icon:
                        Icons.dark_mode_outlined,

                    title: "Darkmode",

                    value: darkModeOn,

                    onChanged: (value) {
                      setState(() {
                        darkModeOn =
                            value;
                      });
                    },
                  ),

                  _menuTile(
                    icon: Icons.logout,

                    title: "Log out",
                  ),
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

      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),

      color: const Color(0xFFF6F6F6),

      child: Text(
        text,

        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // =========================
  // LOCATION TILE
  // =========================
  Widget _locationTile({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          const SizedBox(width: 6),

          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),

      child: Row(
        children: [
          Icon(icon, size: 22),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          if (trailing != null)
            Text(
              trailing,

              style: const TextStyle(
                fontSize: 13,
              ),
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
    required Function(bool)
        onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Row(
        children: [
          Icon(icon, size: 22),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          Switch(
            value: value,

            activeColor: Colors.white,

            activeTrackColor:
                const Color(0xFF00C853),

            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}