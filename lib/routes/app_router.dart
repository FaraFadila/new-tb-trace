import 'package:go_router/go_router.dart';

// ================= AUTH =================
import '../features/auth/start_page.dart';
import '../features/auth/login_page.dart';

// ================= HOME =================
import '../features/home/home_patient_page.dart';
import '../features/home/home_healthcare_page.dart';

// ================= MAP =================
import '../features/map/patient_map_page.dart';

// ================= NEWS =================
import '../features/news/news_page.dart';
import '../features/news/news_patient.dart';
import '../features/news/patient_news_detail_page.dart';
import '../features/news/add_news_page.dart';

// ================= PROFILE =================
import '../features/profile/profile_page.dart';
import '../features/profile/edit_profile_page.dart';

<<<<<<< HEAD
// ================= NEWS =================
import '../features/news/news_page.dart';
import '../features/news/add_news_page.dart';

=======
>>>>>>> ea70854c07b56bdae0f2cd778aefeb5dcbb6f3b7
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
      builder: (context, state) => const StartPage(),
    ),

    // ================= LOGIN =================
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // ================= HOME PATIENT =================
    GoRoute(
      path: '/home-patient',
      builder: (context, state) => const HomePatientPage(),
    ),

    // ================= HOME HEALTHCARE =================
    GoRoute(
      path: '/home-healthcare',
      builder: (context, state) => const HomeHealthcarePage(),
    ),

    // ================= PATIENT MAP =================
    GoRoute(
      path: '/patient-map',
      builder: (context, state) => const PatientMapPage(),
    ),

    // ================= NEWS HEALTHCARE =================
    GoRoute(
      path: '/news-healthcare',
      builder: (context, state) => const NewsPage(),
    ),

    // ================= NEWS PATIENT =================
    GoRoute(
      path: '/news-patient',
      builder: (context, state) => const NewsPatientPage(),
    ),

    // ================= NEWS DETAIL =================
    GoRoute(
      path: '/patient-news-detail',
      builder: (context, state) => const PatientNewsDetailPage(),
    ),

    // ================= ADD NEWS =================
    GoRoute(
      path: '/add-news',
      builder: (context, state) => const TambahBeritaScreen(),
    ),

    // ================= PROFILE =================
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),

    // ================= EDIT PROFILE =================
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),

    // ================= REPORT SYMPTOM =================
    GoRoute(
      path: '/report-symptom',
<<<<<<< HEAD
      builder: (context, state) =>
          const ReportSymptomPage(),
      ),
      
      GoRoute(
      path: '/map',
      builder: (context, state) => const MapPage(),
    ),

=======
      builder: (context, state) => const ReportSymptomPage(),
    ),
>>>>>>> ea70854c07b56bdae0f2cd778aefeb5dcbb6f3b7
  ],
);