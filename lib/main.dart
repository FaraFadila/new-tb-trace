import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tb_trace/routes/app_router.dart'; // Sesuaikan lokasi file-nya

void main() async {
  // 1. Pastikan pondasi inti Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized(); 

  // 2. JURUS PAMUNGKAS: Paksa sistem membaca ukuran layar browser sampai dapat!
  await ScreenUtil.ensureScreenSize(); 

  // 3. Setelah aman, baru jalankan aplikasinya
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Sesuai ukuran frame Figma
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          title: 'TB-Trace',
        );
      },
    );
  }
}