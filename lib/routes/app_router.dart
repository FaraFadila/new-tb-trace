import 'package:go_router/go_router.dart';

// ================= AUTH =================
import '../features/auth/start_page.dart';
import '../features/auth/login_page.dart';

// ================= HOME =================
import '../features/home/home_patient_page.dart';
import '../features/home/home_healthcare_page.dart';

// ================= PROFILE =================
import '../features/profile/profile_page.dart';
import '../features/profile/edit_profile_page.dart';

// ================= PATIENT =================
import '../features/patient/patient_management_page.dart';

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

    // ================= PATIENT MANAGEMENT =================    
    GoRoute(
    path: '/patient-management',
    builder: (context, state) =>
        const PatientManagementPage(),
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
  ],
);