import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tb_trace/core/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  bool rememberMe = false;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Semua field wajib diisi.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Password dan confirm password tidak sama.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password minimal 6 karakter.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final hasActiveSession = await _authService.signUp(
        fullName: name,
        email: email,
        password: password,
        role: AppUserRole.healthcare,
      );

      if (!mounted) return;

      if (hasActiveSession) {
        context.go('/home-healthcare');
      } else {
        _showMessage(
          'Registrasi berhasil. Cek email kamu untuk verifikasi, lalu login.',
        );
        context.go('/login');
      }
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Registrasi gagal. Periksa koneksi internet kamu.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),

            child: Column(
              children: [
                SizedBox(height: 90.h),

                // ================= LOGO =================
                Text(
                  "TB-Trace",

                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w700,

                    color: const Color(0xFF006D37),
                  ),
                ),

                SizedBox(height: 70.h),

                // ================= ILLUSTRATION =================
                SizedBox(
                  width: 281.w,
                  height: 195.h,

                  child: Image.asset(
                    "assets/images/start_illustration.png",

                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 38.h),

                // ================= TITLE =================
                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "Buat Akun",

                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,

                      color: const Color(0xFF006D37),
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                // ================= NAME =================
                TextField(
                  controller: nameController,

                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF006D37),
                    ),

                    hintText: "Name",

                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF006D37),
                    ),

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF06A881).withValues(alpha: 0.32),
                      ),
                    ),

                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF06A881)),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // ================= EMAIL =================
                TextField(
                  controller: emailController,

                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF006D37),
                    ),

                    hintText: "Email",

                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF006D37),
                    ),

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF06A881).withValues(alpha: 0.32),
                      ),
                    ),

                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF06A881)),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // ================= PASSWORD =================
                TextField(
                  controller: passwordController,

                  obscureText: obscurePassword,

                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF006D37),
                    ),

                    hintText: "Password",

                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF006D37),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },

                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,

                        size: 18,

                        color: const Color(0xFF006D37),
                      ),
                    ),

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF06A881).withValues(alpha: 0.32),
                      ),
                    ),

                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF06A881)),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // ================= CONFIRM PASSWORD =================
                TextField(
                  controller: confirmPasswordController,

                  obscureText: obscureConfirmPassword,

                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF006D37),
                    ),

                    hintText: "Confirm Password",

                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF006D37),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },

                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,

                        size: 18,

                        color: const Color(0xFF006D37),
                      ),
                    ),

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF06A881).withValues(alpha: 0.32),
                      ),
                    ),

                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF06A881)),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // ================= REMEMBER =================
                Row(
                  children: [
                    SizedBox(
                      width: 16.w,
                      height: 16.h,

                      child: Checkbox(
                        value: rememberMe,
                        activeColor: const Color(0xFF006D37),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        side: const BorderSide(color: Color(0xFFAEC4BF)),
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                    ),

                    SizedBox(width: 8.w),

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          rememberMe = !rememberMe;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          "Remember me",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF04624B),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    TextButton(
                      onPressed: () {},

                      child: Text(
                        "Forgot password?",

                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF04624B),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ================= BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 48.h,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : _signUp,

                    style: ElevatedButton.styleFrom(
                      elevation: 2,

                      backgroundColor: const Color(0xFF006D37),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),

                    child:
                        isLoading
                            ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              "Sign Up",

                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                SizedBox(height: 16.h),

                // ================= LOGIN =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Sudah punya akun ? ",

                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },

                      child: Text(
                        "Login",

                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF006D37),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
