import 'package:go_router/go_router.dart';
import '../features/news/add_news_page.dart'; 

// ================= AUTH =================
import '../features/auth/start_page.dart';
import '../features/auth/login_page.dart';
import '../features/auth/register_page.dart';

// ================= HOME =================
import '../features/home/home_patient_page.dart';
import '../features/home/home_healthcare_page.dart';

// ================= PROFILE =================
import '../features/profile/profile_page.dart';
import '../features/profile/edit_profile_page.dart';

// ================= NEWS =================
import '../features/news/news_page.dart';
import '../features/news/add_news_page.dart';

// ================= PATIENT =================
import '../features/patient/report_symptom_page.dart';

// ================= MAP =================
import '../features/map/map_page.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    // ================= START =================
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const StartPage(),
    ),

    // ================= LOGIN =================
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          const LoginPage(),
    ),

    // ================= REGISTER  =================
    GoRoute(
    path: '/register',
    builder: (context, state) =>
        const RegisterPage(),
    ),

    // ================= HOME PATIENT =================
    GoRoute(
      path: '/home-patient',
      builder: (context, state) =>
          const HomePatientPage(),
    ),

    // ================= HOME HEALTHCARE =================
    GoRoute(
      path: '/home-healthcare',
      builder: (context, state) =>
          const HomeHealthcarePage(),
    ),

    // ================= PROFILE =================
    GoRoute(
      path: '/profile',
      builder: (context, state) =>
          const ProfilePage(),
    ),

    // ================= EDIT PROFILE =================
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) =>
          const EditProfilePage(),
    ),

    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsPage(),
    ),

    GoRoute(
      path: '/add-news',
      builder: (context, state) => const TambahBeritaScreen(),
    ),
    GoRoute(
      path: '/add-news',
      builder: (context, state) => const TambahBeritaScreen(),
    ),
    // ================= REPORT SYMPTOM =================
    GoRoute(
      path: '/report-symptom',
      builder: (context, state) =>
          const ReportSymptomPage(),
      ),
      
      GoRoute(
      path: '/map',
      builder: (context, state) => const MapPage(),
    ),

  ],
);