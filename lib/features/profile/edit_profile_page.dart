import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tb_trace/core/services/user_profile_service.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.fallbackRoute = '/profile-patient'});

  final String fallbackRoute;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserProfileService _profileService = UserProfileService();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController changePasswordController =
      TextEditingController();

  String selectedCountry = "Indonesia";

  DateTime selectedDate = DateTime(1995, 5, 23);
  bool isSaving = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    emailController.text = _profileService.currentEmail();
    _loadProfileName();
  }

  Future<void> _loadProfileName() async {
    final displayName = await _profileService.currentDisplayName();

    if (!mounted) return;

    nameController.text = displayName;
  }

  Future<void> _saveProfile() async {
    if (isSaving) return;

    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = changePasswordController.text.trim();

    if (fullName.isEmpty) {
      _showMessage('Nama wajib diisi.');
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Email valid wajib diisi.');
      return;
    }

    if (password.isNotEmpty || confirmPassword.isNotEmpty) {
      if (password.length < 6) {
        _showMessage('Password minimal 6 karakter.');
        return;
      }

      if (password != confirmPassword) {
        _showMessage('Konfirmasi password tidak sama.');
        return;
      }
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _profileService.updateAccount(
        fullName: fullName,
        email: email,
        newPassword: password.isEmpty ? null : password,
      );

      if (!mounted) return;

      passwordController.clear();
      changePasswordController.clear();
      _showMessage('Profil berhasil diperbarui.');
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Gagal memperbarui profil. Periksa koneksi internet kamu.');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    changePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF1),
      appBar: AppPageHeader(
        title: 'Edit Profile',
        centerTitle: true,
        fallbackRoute: widget.fallbackRoute,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 12),

              // =========================
              // PROFILE IMAGE
              // =========================
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 140,
                      height: 140,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: const Color(0xFF006D37),
                          width: 3,
                        ),

                        image: const DecorationImage(
                          image: AssetImage("assets/images/profile.png"),

                          fit: BoxFit.cover,
                        ),

                        boxShadow: [
                          BoxShadow(
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 6,
                      right: 6,

                      child: Container(
                        padding: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          shape: BoxShape.circle,

                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black.withValues(alpha: 0.08),
                            ),
                          ],
                        ),

                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Color(0xFF006D37),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // =========================
              // NAME
              // =========================
              _label("Name"),

              const SizedBox(height: 10),

              _inputField(controller: nameController),

              const SizedBox(height: 24),

              // =========================
              // EMAIL
              // =========================
              _label("Email"),

              const SizedBox(height: 10),

              _inputField(controller: emailController),

              const SizedBox(height: 24),

              // =========================
              // PASSWORD
              // =========================
              _label("Password"),

              const SizedBox(height: 10),

              _inputField(
                controller: passwordController,
                obscure: obscurePassword,
                hintText: 'Isi password baru',
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
                    color: const Color(0xFF006D37),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // CHANGE PASSWORD
              // =========================
              _label("Confirm Password"),

              const SizedBox(height: 10),

              _inputField(
                controller: changePasswordController,
                obscure: obscureConfirmPassword,
                hintText: 'Ulangi password baru',
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
                    color: const Color(0xFF006D37),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Kosongkan password kalau tidak ingin menggantinya.',
                style: TextStyle(fontSize: 12, color: Color(0xFF53615C)),
              ),

              const SizedBox(height: 24),

              // =========================
              // DATE OF BIRTH
              // =========================
              _label("Date of Birth"),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,

                    initialDate: selectedDate,

                    firstDate: DateTime(1950),

                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },

                child: _dropdownField(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // COUNTRY
              // =========================
              _label("Country / Region"),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  border: Border.all(color: const Color(0xFFE8F8F1)),

                  borderRadius: BorderRadius.circular(14),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      color: Colors.black.withValues(alpha: 0.02),
                    ),
                  ],
                ),

                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCountry,

                    isExpanded: true,

                    items: const [
                      DropdownMenuItem(
                        value: "Indonesia",

                        child: Text("Indonesia"),
                      ),

                      DropdownMenuItem(
                        value: "Malaysia",

                        child: Text("Malaysia"),
                      ),

                      DropdownMenuItem(
                        value: "Singapore",

                        child: Text("Singapore"),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 42),

              // =========================
              // SAVE BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  onPressed: isSaving ? null : _saveProfile,

                  style: ElevatedButton.styleFrom(
                    elevation: 0,

                    backgroundColor: const Color(0xFF006D37),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child:
                      isSaving
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            "Save Changes",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,

                              color: Colors.white,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // LABEL
  // =========================
  Widget _label(String text) {
    return Text(
      text,

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF171D17),
      ),
    );
  }

  // =========================
  // INPUT FIELD
  // =========================
  Widget _inputField({
    required TextEditingController controller,
    bool obscure = false,
    String? hintText,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        suffixIcon: suffixIcon,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Color(0xFFE8F8F1)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Color(0xFFE8F8F1)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Color(0xFF006D37), width: 1.5),
        ),
      ),
    );
  }

  // =========================
  // DROPDOWN FIELD
  // =========================
  Widget _dropdownField(String text) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: const Color(0xFFE8F8F1)),

        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.02),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              text,

              style: const TextStyle(fontSize: 14, color: Color(0xFF544C4C)),
            ),
          ),

          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF006D37)),
        ],
      ),
    );
  }
}
