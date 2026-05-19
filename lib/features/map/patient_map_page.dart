import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/widgets/patient_bottom_navbar.dart';

class PatientMapPage extends StatelessWidget {
  const PatientMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),

      bottomNavigationBar:
          const PatientBottomNavbar(
        currentIndex: 1,
      ),

      body: Stack(
        children: [
          // ================= MAP BACKGROUND =================
          Positioned.fill(
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1200&auto=format&fit=crop',
                  fit: BoxFit.cover,
                ),

                Container(
                  color: const Color(
                    0xFF064E3B,
                  ).withOpacity(0.05),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          SafeArea(
            child: Stack(
              children: [
                // ================= HEADER =================
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,

                  child: Container(
                    height: 60.h,

                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 24.w,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.9),

                      border: const Border(
                        bottom: BorderSide(
                          color: Color(
                            0xFFD1FAE5,
                          ),
                        ),
                      ),

                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          offset:
                              const Offset(
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
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16.r,

                              backgroundColor:
                                  const Color(
                                0xFFECEEEE,
                              ),

                              child: Icon(
                                Icons.person,
                                size: 18.sp,
                                color:
                                    const Color(
                                  0xFF065F46,
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 12.w,
                            ),

                            Text(
                              "TB-Trace",

                              style: TextStyle(
                                fontSize:
                                    18.sp,

                                fontWeight:
                                    FontWeight
                                        .w700,

                                color:
                                    const Color(
                                  0xFF065F46,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Icon(
                          Iconsax.notification,
                          color:
                              const Color(
                            0xFF059669,
                          ),
                          size: 22.sp,
                        ),
                      ],
                    ),
                  ),
                ),

                // ================= LIVE BADGE =================
                Positioned(
                  top: 80.h,
                  left: 24.w,

                  child: Container(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.75),

                      borderRadius:
                          BorderRadius.circular(
                        12.r,
                      ),

                      border: Border.all(
                        color: Colors.white
                            .withOpacity(
                          0.5,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,

                          decoration:
                              const BoxDecoration(
                            color: Color(
                              0xFF006E1C,
                            ),
                            shape:
                                BoxShape.circle,
                          ),
                        ),

                        SizedBox(
                          width: 8.w,
                        ),

                        Text(
                          "Langsung",

                          style: TextStyle(
                            fontSize: 10.sp,

                            color:
                                const Color(
                              0xFF006E1C,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ================= MAP CONTROLS =================
                Positioned(
                  top: 80.h,
                  right: 24.w,

                  child: Column(
                    children: [
                      _mapButton(
                        Icons.add,
                      ),

                      SizedBox(
                        height: 8.h,
                      ),

                      _mapButton(
                        Icons.remove,
                      ),

                      SizedBox(
                        height: 8.h,
                      ),

                      _mapButton(
                        Icons.my_location,
                        iconColor:
                            const Color(
                          0xFF006E1C,
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= MARKER =================
                Positioned(
                  top: 300.h,
                  right: 80.w,

                  child: Container(
                    width: 48.w,
                    height: 48.h,

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFF4CAF50,
                      ).withOpacity(0.2),

                      shape:
                          BoxShape.circle,
                    ),

                    child: Center(
                      child: Container(
                        width: 40.w,
                        height: 40.h,

                        padding:
                            EdgeInsets.all(
                          2.w,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          border:
                              Border.all(
                            color:
                                const Color(
                              0xFF006E1C,
                            ),
                            width: 2,
                          ),

                          shape:
                              BoxShape.circle,

                          boxShadow: [
                            BoxShadow(
                              blurRadius:
                                  25,
                              offset:
                                  const Offset(
                                0,
                                8,
                              ),
                              color: Colors
                                  .black
                                  .withOpacity(
                                0.15,
                              ),
                            ),
                          ],
                        ),

                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            999.r,
                          ),

                          child: Image.network(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ================= PATIENT CARD =================
                Positioned(
                  left: 20.w,
                  right: 20.w,
                  bottom: 110.h,

                  child: Container(
                    padding:
                        EdgeInsets.all(
                      20.w,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        24.r,
                      ),

                      border: Border.all(
                        color:
                            const Color(
                          0xFFF1F5F9,
                        ),
                      ),

                      boxShadow: [
                        BoxShadow(
                          blurRadius:
                              50,
                          offset:
                              const Offset(
                            0,
                            25,
                          ),
                          color: Colors
                              .black
                              .withOpacity(
                            0.12,
                          ),
                        ),
                      ],
                    ),

                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        // ================= IMAGE =================
                        Stack(
                          children: [
                            Container(
                              width: 64.w,
                              height: 64.h,

                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                  16.r,
                                ),

                                border:
                                    Border.all(
                                  color: Colors
                                      .white,
                                  width: 2,
                                ),

                                image:
                                    const DecorationImage(
                                  image:
                                      NetworkImage(
                                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop',
                                  ),
                                  fit:
                                      BoxFit
                                          .cover,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    blurRadius:
                                        6,
                                    offset:
                                        const Offset(
                                      0,
                                      4,
                                    ),
                                    color: Colors
                                        .black
                                        .withOpacity(
                                      0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              right: -2,
                              bottom: -2,

                              child: Container(
                                width: 20.w,
                                height: 20.h,

                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFF10B981,
                                  ),

                                  shape: BoxShape
                                      .circle,

                                  border:
                                      Border.all(
                                    color:
                                        Colors
                                            .white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 16.w),

                        // ================= INFO =================
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,

                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [
                                      Text(
                                        "Amanda",

                                        style:
                                            TextStyle(
                                          fontSize:
                                              16.sp,

                                          fontWeight:
                                              FontWeight
                                                  .w600,

                                          color:
                                              const Color(
                                            0xFF191C1D,
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height:
                                            4.h,
                                      ),

                                      Text(
                                        "ID: #4492-BX",

                                        style:
                                            TextStyle(
                                          fontSize:
                                              14.sp,

                                          color:
                                              const Color(
                                            0xFF64748B,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(
                                      horizontal:
                                          10.w,
                                      vertical:
                                          4.h,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          const Color(
                                        0xFFFEF9C3,
                                      ),

                                      borderRadius:
                                          BorderRadius.circular(
                                        999.r,
                                      ),
                                    ),

                                    child: Row(
                                      children: [
                                        Container(
                                          width:
                                              6.w,
                                          height:
                                              6.h,

                                          decoration:
                                              const BoxDecoration(
                                            color:
                                                Color(
                                              0xFFEAB308,
                                            ),
                                            shape:
                                                BoxShape.circle,
                                          ),
                                        ),

                                        SizedBox(
                                          width:
                                              6.w,
                                        ),

                                        Text(
                                          "Medium Risk",

                                          style:
                                              TextStyle(
                                            fontSize:
                                                8.sp,

                                            fontWeight:
                                                FontWeight.w700,

                                            color:
                                                const Color(
                                              0xFF854D0E,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 18.h,
                              ),

                              Row(
                                children: [
                                  _infoItem(
                                    "Heart Rate",
                                    "72",
                                    "BPM",
                                  ),

                                  Container(
                                    width: 1.w,
                                    height: 24.h,
                                    color:
                                        const Color(
                                      0xFFF1F5F9,
                                    ),
                                  ),

                                  SizedBox(
                                    width: 16.w,
                                  ),

                                  _infoItem(
                                    "Oxygen",
                                    "98%",
                                    "",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= MAP BUTTON =================
  Widget _mapButton(
    IconData icon, {
    Color iconColor =
        const Color(0xFF3F4A3C),
  }) {
    return Container(
      width: 40.w,
      height: 40.h,

      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.75),

        borderRadius:
            BorderRadius.circular(
          12.r,
        ),

        border: Border.all(
          color:
              Colors.white.withOpacity(
            0.5,
          ),
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: const Offset(0, 1),
            color:
                Colors.black.withOpacity(
              0.05,
            ),
          ),
        ],
      ),

      child: Icon(
        icon,
        color: iconColor,
        size: 20.sp,
      ),
    );
  }

  // ================= INFO ITEM =================
  Widget _infoItem(
    String label,
    String value,
    String suffix,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        right: 16.w,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            label,

            style: TextStyle(
              fontSize: 9.sp,

              color: const Color(
                0xFF94A3B8,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          Row(
            children: [
              Text(
                value,

                style: TextStyle(
                  fontSize: 16.sp,

                  fontWeight:
                      FontWeight.w700,

                  color: const Color(
                    0xFF191C1D,
                  ),
                ),
              ),

              if (suffix.isNotEmpty)
                Padding(
                  padding:
                      EdgeInsets.only(
                    left: 4.w,
                  ),

                  child: Text(
                    suffix,

                    style: TextStyle(
                      fontSize: 10.sp,

                      color:
                          const Color(
                        0xFF94A3B8,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}