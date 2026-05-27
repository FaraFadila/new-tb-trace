import 'package:go_router/go_router.dart';

import '../core/services/news_api_service.dart';

// ================= AUTH =================
import '../features/auth/start_page.dart';
import '../features/auth/login_page.dart';
import '../features/auth/register_page.dart';

// ================= HOME =================
import '../features/home/home_patient_page.dart';
import '../features/home/home_healthcare_page.dart';

// ================= MAP =================
import '../features/map/map_page.dart';
import '../features/map/patient_map_page.dart';

// ================= NEWS =================
import '../features/news/add_news_page.dart';
import '../features/news/healthcare_news_detail_page.dart';
import '../features/news/news_page.dart';
import '../features/news/news_patient.dart';
import '../features/news/patient_news_detail_page.dart';

// ================= PATIENT =================
import '../features/patient/add_patient_page.dart';
import '../features/patient/patient_detail_page.dart';
import '../features/patient/patient_management_page.dart';
import '../features/patient/report_symptom_page.dart';

// ================= PROFILE =================
import '../features/profile/edit_profile_page.dart';
import '../features/profile/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ================= START =================
    GoRoute(path: '/', builder: (context, state) => const StartPage()),

    // ================= LOGIN =================
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    // ================= REGISTER =================
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    // ================= HOME =================
    GoRoute(
      path: '/home-patient',
      builder: (context, state) => const HomePatientPage(),
    ),
    GoRoute(
      path: '/home-healthcare',
      builder: (context, state) => const HomeHealthcarePage(),
    ),

    // ================= MAP =================
    GoRoute(path: '/map', builder: (context, state) => const MapPage()),
    GoRoute(
      path: '/patient-map',
      builder: (context, state) => const PatientMapPage(),
    ),

    // ================= NEWS =================
    GoRoute(path: '/news', builder: (context, state) => const NewsPage()),
    GoRoute(
      path: '/news-healthcare',
      builder: (context, state) => const NewsPage(),
    ),
    GoRoute(
      path: '/news-patient',
      builder: (context, state) => const NewsPatientPage(),
    ),
    GoRoute(
      path: '/patient-news-detail',
      builder:
          (context, state) => PatientNewsDetailPage(
            article:
                state.extra is NewsApiArticle
                    ? state.extra as NewsApiArticle
                    : null,
          ),
    ),
    GoRoute(
      path: '/healthcare-news-detail',
      builder:
          (context, state) => HealthcareNewsDetailPage(
            article:
                state.extra is HealthcareNewsArticle
                    ? state.extra as HealthcareNewsArticle
                    : null,
          ),
    ),
    GoRoute(
      path: '/add-news',
      builder: (context, state) => const TambahBeritaScreen(),
    ),

    // ================= PATIENT =================
    GoRoute(
      path: '/patient-management',
      builder: (context, state) => const PatientManagementPage(),
    ),
    GoRoute(
      path: '/add-patient',
      builder: (context, state) => const AddPatientPage(),
    ),
    GoRoute(
      path: '/patient-detail/:id',
      builder:
          (context, state) =>
              PatientDetailPage(patientId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/patients',
      redirect: (context, state) => '/patient-management',
    ),
    GoRoute(
      path: '/report-symptom',
      builder: (context, state) => const ReportSymptomPage(),
    ),

    // ================= PROFILE =================
    GoRoute(path: '/profile', redirect: (context, state) => '/profile-patient'),
    GoRoute(
      path: '/profile-patient',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/profile-healthcare',
      builder: (context, state) => const ProfilePage(isHealthcare: true),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
  ],
);
