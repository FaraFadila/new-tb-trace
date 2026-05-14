import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/patient_bottom_navbar.dart';
import 'patient_news_detail_page.dart';

class PatientNewsDetailPage extends StatelessWidget {
  const PatientNewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),

      // ================= APP BAR =================
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.h),

        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),

          decoration: BoxDecoration(
            color:
                Colors.white.withOpacity(
              0.95,
            ),

            border: const Border(
              bottom: BorderSide(
                color: Color(
                  0xFFE8F8F1,
                ),
              ),
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(
                  0.04,
                ),

                blurRadius: 20,
                offset: const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: SafeArea(
            child: Row(
              children: [
                Icon(
                  Icons.notifications,
                  size: 20.sp,
                ),

                const Spacer(),

                Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  crossAxisAlignment:
                      CrossAxisAlignment.end,

                  children: [
                    Text(
                      "Hello,",

                      style: TextStyle(
                        fontSize: 12.sp,

                        color:
                            Colors.black54,
                      ),
                    ),

                    Text(
                      "Jade West",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,

                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 12.w),

                Container(
                  width: 44.w,
                  height: 44.h,

                  decoration:
                      const BoxDecoration(
                    color: Color(
                      0xFFEEF2F3,
                    ),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            SizedBox(height: 24.h),

            // ================= TITLE =================
            Center(
              child: Text(
                "Berita TBC",

                style: TextStyle(
                  fontSize: 28.sp,

                  fontWeight:
                      FontWeight.bold,

                  color: const Color(
                    0xFF019784,
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // ================= SEARCH =================
            Container(
              height: 55.h,

              padding:
                  EdgeInsets.symmetric(
                horizontal: 16.w,
              ),

              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),

                borderRadius:
                    BorderRadius.circular(
                  30.r,
                ),
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: TextField(
                      decoration:
                          InputDecoration(
                        hintText:
                            "Cari Berita",

                        hintStyle:
                            TextStyle(
                          fontSize:
                              14.sp,
                        ),

                        border:
                            InputBorder.none,
                      ),
                    ),
                  ),

                  Container(
                    padding:
                        EdgeInsets.all(
                      8.w,
                    ),

                    decoration:
                        const BoxDecoration(
                      shape:
                          BoxShape.circle,

                      gradient:
                          LinearGradient(
                        colors: [
                          Color(
                            0xFF006D37,
                          ),
                          Color(
                            0xFF27AE60,
                          ),
                        ],
                      ),
                    ),

                    child: Icon(
                      Icons.arrow_forward,
                      color:
                          Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ================= CATEGORY =================
            SizedBox(
              height: 38.h,

              child: ListView(
                scrollDirection:
                    Axis.horizontal,

                children: const [
                  CategoryChip(
                    title: "All",
                    isActive: true,
                  ),

                  SizedBox(width: 10),

                  CategoryChip(
                    title: "Pengobatan",
                  ),

                  SizedBox(width: 10),

                  CategoryChip(
                    title: "Pencegahan",
                  ),

                  SizedBox(width: 10),

                  CategoryChip(
                    title: "Nutrisi",
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ================= ARTICLES =================
            const ArticleCard(
              image:
                  "assets/images/article1.jpg",

              title:
                  "Bahaya Putus Obat (TBC RO)",

              category: "Pengobatan",

              author: "Dr. Patrick",
            ),

            SizedBox(height: 16.h),

            const ArticleCard(
              image:
                  "assets/images/article2.jpg",

              title:
                  "Waspada TBC pada Anak",

              category: "Pencegahan",

              author: "Dr. Stanzel",
            ),

            SizedBox(height: 16.h),

            const ArticleCard(
              image:
                  "assets/images/article3.jpg",

              title:
                  "Mitos dan Fakta Seputar TBC",

              category: "Pencegahan",

              author: "Dr. Stanpat",
            ),

            SizedBox(height: 16.h),

            const ArticleCard(
              image:
                  "assets/images/article4.jpg",

              title:
                  "Atasi Stigma Pasien TBC",

              category: "Pencegahan",

              author: "Dr. Panpan",
            ),

            SizedBox(height: 120.h),
          ],
        ),
      ),

      // ================= NAVBAR =================
      bottomNavigationBar:
          const PatientBottomNavbar(
        currentIndex: 2,
      ),
    );
  }
}

// ================= CATEGORY CHIP =================
class CategoryChip extends StatelessWidget {
  final String title;
  final bool isActive;

  const CategoryChip({
    super.key,
    required this.title,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal: 18.w,
      ),

      decoration: BoxDecoration(
        gradient:
            isActive
                ? const LinearGradient(
                    colors: [
                      Color(
                        0xFF006D37,
                      ),
                      Color(
                        0xFF27AE60,
                      ),
                    ],
                  )
                : null,

        color:
            isActive
                ? null
                : const Color(
                    0xFF171616,
                  ),

        borderRadius:
            BorderRadius.circular(
          30.r,
        ),
      ),

      alignment: Alignment.center,

      child: Text(
        title,

        style: TextStyle(
          color:
              isActive
                  ? Colors.white
                  : Colors.grey[400],

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}

// ================= ARTICLE CARD =================
class ArticleCard extends StatelessWidget {
  final String image;
  final String title;
  final String category;
  final String author;

  const ArticleCard({
    super.key,
    required this.image,
    required this.title,
    required this.category,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/patient-news-detail',
        );
      },

      child: Container(
        height: 137.h,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            16.r,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(
                0.12,
              ),

              blurRadius: 10,
            ),
          ],
        ),

        child: Row(
          children: [
            // ================= IMAGE =================
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                16.r,
              ),

              child: Image.asset(
                image,

                width: 144.w,
                height: 137.h,

                fit: BoxFit.cover,
              ),
            ),

            // ================= CONTENT =================
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.all(
                  14.w,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,

                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      category,

                      style: TextStyle(
                        fontSize: 11.sp,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "$author | 5 min read",

                      style: TextStyle(
                        fontSize: 10.sp,

                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}