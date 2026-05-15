import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/healthcare_bottom_navbar.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: const Color(0xFFF8FAFA),

      // ================= BOTTOM NAVBAR =================
      bottomNavigationBar:
          const HealthcareBottomNavbar(
        currentIndex: 1,
      ),

      body: Stack(
        children: [

          // ================= MAP BACKGROUND =================
          Container(
            width: double.infinity,
            height: double.infinity,

            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFA),

              image: DecorationImage(
                image: AssetImage(
                  'assets/images/map_placeholder.png',
                ),

                fit: BoxFit.cover,
              ),
            ),
          ),

          // ================= GREEN OVERLAY =================
          Container(
            width: double.infinity,
            height: double.infinity,

            color: const Color(
              0xFF064E3B,
            ).withOpacity(0.05),
          ),

          // ================= MAP PINS =================
          Positioned(
            left: 68,
            top: 375,

            child: _buildMapPin(
              const Color(0xFFBF0A0A),
            ),
          ),

          Positioned(
            right: 80,
            top: 425,

            child: _buildMapPin(
              const Color(0xFF878312),
            ),
          ),

          Positioned(
            left: 121,
            top: 682,

            child: _buildMapPin(
              const Color(0xFF4D7B4F),
            ),
          ),

          // ================= LIVE BADGE =================
          Positioned(
            left: 24,
            top: 100,

            child: _buildGlassContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,

                    decoration: const BoxDecoration(
                      color: Color(0xFF006E1C),
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 6),

                  const Text(
                    "Langsung",

                    style: TextStyle(
                      color: Color(0xFF006E1C),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= MAP CONTROLS =================
          Positioned(
            right: 24,
            top: 100,

            child: Column(
              children: [
                _buildMapControlButton(
                  Icons.add,
                ),

                const SizedBox(height: 8),

                _buildMapControlButton(
                  Icons.remove,
                ),

                const SizedBox(height: 8),

                _buildMapControlButton(
                  Icons.my_location,
                ),
              ],
            ),
          ),

          // ================= TOP APPBAR =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,

            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),

                child: Container(
                  padding: const EdgeInsets.only(
                    top: 40,
                    bottom: 12,
                    left: 24,
                    right: 24,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.9,
                    ),

                    border: const Border(
                      bottom: BorderSide(
                        color: Color(0xFFD1FAE5),
                      ),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.04,
                        ),

                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF1C274C),
                      ),

                      const Spacer(),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,

                        children: const [
                          Text(
                            "Hello,",

                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),

                          Text(
                            "Jade West",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 12),

                      const CircleAvatar(
                        backgroundColor:
                            Color(0xFFEEF2F3),

                        radius: 20,

                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= GLASS CONTAINER =================
  Widget _buildGlassContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),

        child: Container(
          padding: padding,

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              0.75,
            ),

            borderRadius:
                BorderRadius.circular(12),

            border: Border.all(
              color: Colors.white.withOpacity(
                0.5,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.05,
                ),

                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),

          child: child,
        ),
      ),
    );
  }

  // ================= MAP CONTROL BUTTON =================
  Widget _buildMapControlButton(
    IconData icon,
  ) {
    return _buildGlassContainer(
      child: IconButton(
        onPressed: () {},

        icon: Icon(
          icon,
          color: const Color(0xFF3F4A3C),
          size: 20,
        ),

        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),

        padding: EdgeInsets.zero,
      ),
    );
  }

  // ================= MAP PIN =================
  Widget _buildMapPin(Color color) {
    return Container(
      width: 28,
      height: 35,

      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,

        border: Border.all(
          color: Colors.white,
          width: 2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.2,
            ),

            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: const Center(
        child: Icon(
          Icons.circle,
          color: Colors.white,
          size: 8,
        ),
      ),
    );
  }
}