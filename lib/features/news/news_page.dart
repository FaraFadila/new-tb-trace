import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_trace/core/widgets/healthcare_bottom_navbar.dart';

import 'patient_news_detail_page.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF1),

      appBar: _buildAppBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildSearchBar(),

              const SizedBox(height: 16),

              _buildFilterChips(),

              const SizedBox(height: 24),

              _buildNewsList(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 2),

      floatingActionButton: Container(
        height: 56,
        width: 56,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,

            colors: [Color(0xFF006D37), Color(0xFF61DE8A)],
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFF006D37).withOpacity(0.3),

              blurRadius: 15,

              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: FloatingActionButton(
          onPressed: () {
            context.push('/add-news');
          },

          backgroundColor: Colors.transparent,

          elevation: 0,

          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // ================= APP BAR =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),

      elevation: 0,

      surfaceTintColor: Colors.transparent,

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),

        child: Container(color: const Color(0xFFE8F8F1), height: 1),
      ),

      leading: IconButton(
        icon: const Icon(Icons.notifications_none, color: Color(0xFF1C274C)),

        onPressed: () {},
      ),

      title: const Column(
        children: [
          Text(
            'Hello,',

            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF1E1E1E),
              fontWeight: FontWeight.w400,
            ),
          ),

          Text(
            'Jade West',

            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1E1E1E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),

      centerTitle: true,

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),

          child: CircleAvatar(
            backgroundColor: const Color(0xFFEEF2F3),

            radius: 20,

            child: Icon(Icons.person, color: Colors.blue[300]),
          ),
        ),
      ],
    );
  }

  // ================= SEARCH BAR =================
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFBCCABC)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 20,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search medical news...',

          hintStyle: TextStyle(color: Color(0xFF3D4A3F), fontSize: 16),

          prefixIcon: Icon(Icons.search, color: Color(0xFF3D4A3F)),

          border: InputBorder.none,

          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ================= FILTER =================
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Row(
        children: [
          _buildChip('All', isActive: true),

          _buildChip('Pencegahan'),

          _buildChip('Pengobatan'),

          _buildChip('Nutrisi'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF006D37) : const Color(0xFFDDE5DB),

          borderRadius: BorderRadius.circular(8),
        ),

        child: Text(
          label,

          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF3D4A3F),

            fontWeight: FontWeight.bold,

            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ================= NEWS LIST =================
  Widget _buildNewsList() {
    return Column(
      children: [
        _buildNewsCard(
          tag: 'Pencegahan',
          title: 'New Protocol for MDR-TB Showing 85% Efficacy in Early...',
          description:
              'Recent clinical trials suggest that combining Bedaquiline with the novel compound shows unprecedented clearance rates in multidrug-resistant TB.',
          footerContent: Row(
            children: const [
              Icon(Icons.check_circle, size: 12, color: Color(0xFF006D37)),

              SizedBox(width: 4),

              Text(
                'VERIFIED BY DR. ZORO',

                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF006D37),
                  fontWeight: FontWeight.bold,
                ),
              ),

              Spacer(),

              Icon(Icons.open_in_new, size: 18, color: Color(0xFF006D37)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildNewsCard(
          tag: 'Nutrisi',
          title: 'New Protocol for MDR-TB Showing 85% Efficacy in Early...',
          description:
              'Recent clinical trials suggest that combining Bedaquiline with the novel compound shows unprecedented clearance rates in multidrug-...',
          footerContent: Row(
            children: const [
              Icon(Icons.check_circle, size: 12, color: Color(0xFF006D37)),
              SizedBox(width: 4),
              Text(
                'VERIFIED BY DR. ZORO',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF006D37),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(Icons.open_in_new, size: 18, color: Color(0xFF006D37)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildNewsCard(
          tag: 'Pencegahan',
          title: 'New Protocol for MDR-TB Showing 85% Efficacy in Early...',
          description:
              'Recent clinical trials suggest that combining Bedaquiline with the novel compound shows unprecedented clearance rates in multidrug-...',
          footerContent: Row(
            children: const [
              Icon(Icons.check_circle, size: 12, color: Color(0xFF006D37)),
              SizedBox(width: 4),
              Text(
                'VERIFIED BY DR. ZORO',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF006D37),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(Icons.open_in_new, size: 18, color: Color(0xFF006D37)),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  // ================= NEWS CARD =================
  Widget _buildNewsCard({
    required String tag,
    bool showVerifiedBadge = false,
    required String title,
    required String description,
    required Widget footerContent,
  }) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            context.push('/patient-news-detail');
          },

          child: Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: const Color(0xFFBCCABC)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),

                  blurRadius: 20,

                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFD6E6DF),

                        borderRadius: BorderRadius.circular(6),
                      ),

                      child: Text(
                        tag,

                        style: const TextStyle(
                          fontSize: 12,

                          fontWeight: FontWeight.bold,

                          color: Color(0xFF596862),
                        ),
                      ),
                    ),

                    if (showVerifiedBadge)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFF006D37).withOpacity(0.1),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              size: 12,
                              color: Color(0xFF006D37),
                            ),

                            SizedBox(width: 4),

                            Text(
                              'Verified',

                              style: TextStyle(
                                fontSize: 12,

                                fontWeight: FontWeight.bold,

                                color: Color(0xFF006D37),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.w600,

                    color: Color(0xFF171D17),

                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,

                  style: const TextStyle(
                    fontSize: 14,

                    color: Color(0xFF3D4A3F),

                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                const Divider(color: Color(0xFFDDE5DB)),

                const SizedBox(height: 8),

                footerContent,
              ],
            ),
          ),
        );
      },
    );
  }
}
