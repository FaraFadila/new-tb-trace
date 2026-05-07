import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/home/home_patient_page.dart';

class TBTraceApp extends StatelessWidget {
  const TBTraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },

      // GANTI HALAMAN DISINI
      child: const HomePatientPage(),
    );
  }
}