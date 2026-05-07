import 'package:flutter/material.dart';

class UpdatePatientStatusBottomSheet
    extends StatefulWidget {
  const UpdatePatientStatusBottomSheet({
    super.key,
  });

  @override
  State<UpdatePatientStatusBottomSheet>
      createState() =>
          _UpdatePatientStatusBottomSheetState();
}

class _UpdatePatientStatusBottomSheetState
    extends State<
        UpdatePatientStatusBottomSheet> {
  double progress = 65;

  String selectedRisk = "Medium";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
        bottom: 32,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: Color.fromRGBO(
              0,
              0,
              0,
              0.08,
            ),
            offset: Offset(0, -8),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // HANDLE
          Center(
            child: Container(
              width: 48,
              height: 6,

              decoration: BoxDecoration(
                color: const Color(
                  0xFFE1E3E3,
                ),

                borderRadius:
                    BorderRadius.circular(
                  999,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // TITLE
          const Text(
            "Update Patient Status",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF191C1D),
            ),
          ),

          const SizedBox(height: 16),

          // PATIENT CHIP
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: const Color(
                0xFFD9E6DA,
              ).withOpacity(0.5),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              border: Border.all(
                color:
                    const Color(0xFFD9E6DA),
              ),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(
                    "assets/images/profile.png",
                  ),
                ),

                const SizedBox(width: 12),

                const Text(
                  "Jane Cooper",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w500,
                    color: Color(
                      0xFF5B675E,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // PROGRESS
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              const Text(
                "Proses Pengobatan",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w500,
                  color: Color(
                    0xFF3F4A3C,
                  ),
                ),
              ),

              Text(
                "${progress.toInt()}%",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w700,
                  color: Color(
                    0xFF006E1C,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SliderTheme(
            data: SliderTheme.of(
              context,
            ).copyWith(
              activeTrackColor:
                  const Color(0xFF006E1C),

              inactiveTrackColor:
                  const Color(0xFFE1E3E3),

              thumbColor:
                  const Color(0xFF006E1C),

              overlayColor:
                  const Color(
                0x33006E1C,
              ),

              trackHeight: 10,
            ),

            child: Slider(
              value: progress,
              min: 0,
              max: 100,

              onChanged: (value) {
                setState(() {
                  progress = value;
                });
              },
            ),
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: const [
              Text(
                "0%",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(
                    0xFF6F7A6B,
                  ),
                ),
              ),

              Text(
                "100%",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(
                    0xFF6F7A6B,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // RISK LEVEL
          const Text(
            "Risk Level",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3F4A3C),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(4),

            decoration: BoxDecoration(
              color: const Color(
                0xFFECEEEE,
              ),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: Row(
              children: [
                _riskButton("Low"),
                _riskButton("Medium"),
                _riskButton("High"),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,

            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },

              style:
                  ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                    Colors.transparent,
                shadowColor:
                    Colors.transparent,
                padding: EdgeInsets.zero,
              ),

              child: Ink(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFF006D37),
                      Color(0xFF27AE60),
                    ],
                  ),
                ),

                child: const Center(
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskButton(String title) {
    final bool isSelected =
        selectedRisk == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRisk = title;
          });
        },

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.transparent,

            borderRadius:
                BorderRadius.circular(
              8,
            ),

            border: isSelected
                ? Border.all(
                    color:
                        const Color(
                      0xFFBECAB9,
                    ).withOpacity(0.3),
                  )
                : null,

            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color:
                          Color.fromRGBO(
                        0,
                        0,
                        0,
                        0.05,
                      ),
                      blurRadius: 2,
                    ),
                  ]
                : [],
          ),

          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight.w500,
                color: isSelected
                    ? const Color(
                        0xFF191C1D,
                      )
                    : const Color(
                        0xFF6F7A6B,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}