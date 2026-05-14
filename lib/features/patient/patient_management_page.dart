import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PatientManagementPage extends StatelessWidget {
  const PatientManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},

        elevation: 10,

        backgroundColor: const Color(0xFF006D37),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16.r),
        ),

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      bottomNavigationBar: Container(
        height: 70.h,

        decoration: const BoxDecoration(
          color: Colors.white,

          border: Border(
            top: BorderSide(
              color: Color(0xFFE2E8F0),
            ),
          ),
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,

          children: [
            _navItem(
              icon: Iconsax.home_15,
              label: "Home",
            ),

            _navItem(
              icon: Iconsax.map_15,
              label: "Map",
            ),

            _navItem(
              icon:
                  Iconsax.document_text_15,
              label: "News",
            ),

            _navItem(
              icon:
                  Iconsax.profile_2user,
              label: "Patients",
              active: true,
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),

              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(
                  0.9,
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
                    blurRadius: 20,
                    offset: const Offset(
                      0,
                      4,
                    ),
                    color: Colors.black
                        .withOpacity(
                      0.04,
                    ),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [
                  const Icon(
                    Icons
                        .notifications_none_rounded,

                    size: 26,
                  ),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,

                        children: [
                          Text(
                            "Hello,",

                            style: TextStyle(
                              fontSize:
                                  12.sp,

                              color:
                                  Colors
                                      .black54,
                            ),
                          ),

                          Text(
                            "Jade West",

                            style: TextStyle(
                              fontSize:
                                  15.sp,

                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: 10.w,
                      ),

                      CircleAvatar(
                        radius: 22.r,

                        backgroundColor:
                            const Color(
                          0xFFEEF2F3,
                        ),

                        child: Icon(
                          Icons.person,
                          size: 24.sp,
                          color:
                              const Color(
                            0xFF2EB5FA,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================= BODY =================
            Expanded(
              child:
                  SingleChildScrollView(
                padding:
                    EdgeInsets.all(16.w),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    // ================= TITLE =================
                    Text(
                      "Manajemen Pasien",

                      style: TextStyle(
                        fontSize: 34.sp,

                        fontWeight:
                            FontWeight
                                .w700,

                        color:
                            const Color(
                          0xFF191C1D,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ================= SEARCH =================
                    Container(
                      height: 52.h,

                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          12.r,
                        ),

                        border: Border.all(
                          color:
                              const Color(
                            0xFFE1E3E3,
                          ),
                        ),

                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            offset:
                                const Offset(
                              0,
                              1,
                            ),
                            color: Colors
                                .black
                                .withOpacity(
                              0.05,
                            ),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color(
                              0xFFBECAB9,
                            ),
                          ),

                          SizedBox(
                            width: 12.w,
                          ),

                          Expanded(
                            child: TextField(
                              decoration:
                                  InputDecoration(
                                hintText:
                                    "Cari Pasien...",

                                hintStyle:
                                    TextStyle(
                                  color:
                                      const Color(
                                    0xFF6B7280,
                                  ),

                                  fontSize:
                                      16.sp,
                                ),

                                border:
                                    InputBorder
                                        .none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ================= FILTER =================
                    Row(
                      children: [
                        _filterChip(
                          "All Patients",
                          active: true,
                        ),

                        SizedBox(
                          width: 8.w,
                        ),

                        _filterChip(
                          "High Risk",
                        ),

                        SizedBox(
                          width: 8.w,
                        ),

                        _filterChip(
                          "Update Terbaru",
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // ================= PATIENT LIST =================
                    _patientCard(
                      name: "Jane Cooper",
                      id: "PT-8472",
                      risk: "High Risk",
                      riskColor:
                          const Color(
                        0xFFBA1A1A,
                      ),
                      riskBg:
                          const Color(
                        0xFFFFDAD6,
                      ),
                      progress: 0.45,
                      day: "Day 45 of 90",
                      updated: "Today",
                    ),

                    SizedBox(height: 16.h),

                    _patientCard(
                      name: "Robert Fox",
                      id: "PT-3921",
                      risk: "Medium Risk",
                      riskColor:
                          const Color(
                        0xFFEAB308,
                      ),
                      riskBg:
                          const Color(
                        0xFFFEF9C3,
                      ),
                      progress: 0.13,
                      day: "Day 12 of 90",
                      updated: "2 days ago",
                    ),

                    SizedBox(height: 16.h),

                    _patientCard(
                      name: "Esther Howard",
                      id: "PT-1049",
                      risk: "Low Risk",
                      riskColor:
                          const Color(
                        0xFF5DAC5B,
                      ),
                      riskBg:
                          const Color(
                        0xFFD9E6DA,
                      ),
                      progress: 0.94,
                      day: "Day 85 of 90",
                      updated: "1 week ago",
                    ),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FILTER CHIP =================
  Widget _filterChip(
    String label, {
    bool active = false,
  }) {
    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),

      decoration: BoxDecoration(
        color:
            active
                ? const Color(
                    0xFF4CAF50,
                  )
                : Colors.white,

        borderRadius:
            BorderRadius.circular(
          999.r,
        ),

        border:
            active
                ? null
                : Border.all(
                    color:
                        const Color(
                      0xFFBECAB9,
                    ),
                  ),
      ),

      child: Text(
        label,

        style: TextStyle(
          fontSize: 12.sp,

          fontWeight:
              FontWeight.w700,

          color:
              active
                  ? const Color(
                      0xFF003C0B,
                    )
                  : const Color(
                      0xFF3F4A3C,
                    ),
        ),
      ),
    );
  }

  // ================= PATIENT CARD =================
  Widget _patientCard({
    required String name,
    required String id,
    required String risk,
    required Color riskColor,
    required Color riskBg,
    required double progress,
    required String day,
    required String updated,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          12.r,
        ),

        border: Border.all(
          color:
              const Color(
            0xFFF2F4F4,
          ),
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(
              0,
              4,
            ),
            color:
                Colors.black.withOpacity(
              0.04,
            ),
          ),
        ],
      ),

      child: Column(
        children: [
          // ================= TOP =================
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,

                    backgroundColor:
                        const Color(
                      0xFFECEEEE,
                    ),

                    child: Text(
                      name[0],

                      style: TextStyle(
                        fontSize: 20.sp,

                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        name,

                        style:
                            TextStyle(
                          fontSize:
                              22.sp,

                          fontWeight:
                              FontWeight
                                  .w500,
                        ),
                      ),

                      SizedBox(
                        height: 2.h,
                      ),

                      Text(
                        "ID: $id",

                        style:
                            TextStyle(
                          fontSize:
                              14.sp,

                          color:
                              const Color(
                            0xFF3F4A3C,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Container(
                padding:
                    EdgeInsets.symmetric(
                  horizontal:
                      10.w,
                  vertical: 5.h,
                ),

                decoration:
                    BoxDecoration(
                  color: riskBg,

                  borderRadius:
                      BorderRadius.circular(
                    999.r,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.h,

                      decoration:
                          BoxDecoration(
                        color: riskColor,
                        shape:
                            BoxShape.circle,
                      ),
                    ),

                    SizedBox(
                      width: 6.w,
                    ),

                    Text(
                      risk,

                      style:
                          TextStyle(
                        fontSize:
                            12.sp,

                        fontWeight:
                            FontWeight
                                .w700,

                        color:
                            riskColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          // ================= PROGRESS =================
          Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [
                  Text(
                    "Progres Pengobatan",

                    style: TextStyle(
                      fontSize: 14.sp,

                      color:
                          const Color(
                        0xFF3F4A3C,
                      ),
                    ),
                  ),

                  Text(
                    day,

                    style: TextStyle(
                      fontSize: 12.sp,

                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  999.r,
                ),

                child:
                    LinearProgressIndicator(
                  value: progress,

                  minHeight: 6.h,

                  backgroundColor:
                      const Color(
                    0xFFD9E6DA,
                  ),

                  valueColor:
                      const AlwaysStoppedAnimation(
                    Color(0xFF006E1C),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          // ================= BOTTOM =================
          Container(
            padding:
                EdgeInsets.only(
              top: 16.h,
            ),

            decoration:
                const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(
                    0xFFE1E3E3,
                  ),
                ),
              ),
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [
                Row(
                  children: [
                    const Icon(
                      Icons
                          .calendar_today_outlined,

                      size: 14,

                      color:
                          Color(
                        0xFF3F4A3C,
                      ),
                    ),

                    SizedBox(width: 6.w),

                    Text(
                      "Last updated: $updated",

                      style: TextStyle(
                        fontSize: 14.sp,

                        color:
                            const Color(
                          0xFF3F4A3C,
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal:
                        12.w,
                    vertical: 6.h,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFECEEEE,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      8.r,
                    ),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 12,
                        color:
                            Color(
                          0xFF006E1C,
                        ),
                      ),

                      SizedBox(
                        width: 6.w,
                      ),

                      Text(
                        "Update",

                        style:
                            TextStyle(
                          fontSize:
                              12.sp,

                          fontWeight:
                              FontWeight
                                  .w700,

                          color:
                              const Color(
                            0xFF006E1C,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= NAV ITEM =================
  Widget _navItem({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [
        Icon(
          icon,
          size: 20,

          color:
              active
                  ? const Color(
                      0xFF006E1C,
                    )
                  : const Color(
                      0xFF94A3B8,
                    ),
        ),

        SizedBox(height: 4.h),

        Text(
          label,

          style: TextStyle(
            fontSize: 11.sp,

            fontWeight:
                active
                    ? FontWeight.w700
                    : FontWeight.w500,

            color:
                active
                    ? const Color(
                        0xFF006E1C,
                      )
                    : const Color(
                        0xFF94A3B8,
                      ),
          ),
        ),
      ],
    );
  }
}