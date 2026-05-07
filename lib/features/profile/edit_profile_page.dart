import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  final TextEditingController nameController =
      TextEditingController(
    text: "Melissa Peters",
  );

  final TextEditingController emailController =
      TextEditingController(
    text: "melpeters@gmail.com",
  );

  final TextEditingController passwordController =
      TextEditingController(
    text: "************",
  );

  final TextEditingController changePasswordController =
      TextEditingController(
    text: "************",
  );

  String selectedCountry = "Nigeria";

  DateTime selectedDate =
      DateTime(1995, 5, 23);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // =========================
              // HEADER
              // =========================
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },

                    icon: const Icon(
                      Icons
                          .arrow_back_ios_new,
                      color: Color(
                        0xFF1C274C,
                      ),
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:
                          FontWeight.w700,
                      color: Color(
                        0xFF006D37,
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),

              const SizedBox(height: 28),

              // =========================
              // PROFILE IMAGE
              // =========================
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 140,
                      height: 140,

                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,

                        border:
                            Border.all(
                          color: const Color(
                            0xFF242760,
                          ),
                        ),

                        image:
                            const DecorationImage(
                          image: AssetImage(
                            "assets/images/profile.png",
                          ),

                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 6,
                      right: 6,

                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          6,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          shape:
                              BoxShape.circle,

                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color:
                                  Colors
                                      .black12,
                            ),
                          ],
                        ),

                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Color(
                            0xFF242760,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // =========================
              // NAME
              // =========================
              _label("Name"),

              const SizedBox(height: 10),

              _inputField(
                controller:
                    nameController,
              ),

              const SizedBox(height: 24),

              // =========================
              // EMAIL
              // =========================
              _label("Email"),

              const SizedBox(height: 10),

              _inputField(
                controller:
                    emailController,
              ),

              const SizedBox(height: 24),

              // =========================
              // PASSWORD
              // =========================
              _label("Password"),

              const SizedBox(height: 10),

              _inputField(
                controller:
                    passwordController,
                obscure: true,
              ),

              const SizedBox(height: 24),

              // =========================
              // CHANGE PASSWORD
              // =========================
              _label("Change Password"),

              const SizedBox(height: 10),

              _inputField(
                controller:
                    changePasswordController,
                obscure: true,
              ),

              const SizedBox(height: 24),

              // =========================
              // DATE OF BIRTH
              // =========================
              _label("Date of Birth"),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () async {
                  DateTime?
                      pickedDate =
                      await showDatePicker(
                    context: context,

                    initialDate:
                        selectedDate,

                    firstDate:
                        DateTime(1950),

                    lastDate:
                        DateTime.now(),
                  );

                  if (pickedDate !=
                      null) {
                    setState(() {
                      selectedDate =
                          pickedDate;
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
              _label("Country/Region"),

              const SizedBox(height: 10),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                ),

                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        Colors.black12,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    6,
                  ),
                ),

                child:
                    DropdownButtonHideUnderline(
                  child: DropdownButton<
                      String>(
                    value:
                        selectedCountry,

                    isExpanded: true,

                    items: const [
                      DropdownMenuItem(
                        value: "Nigeria",
                        child: Text(
                          "Nigeria",
                        ),
                      ),

                      DropdownMenuItem(
                        value: "Indonesia",
                        child: Text(
                          "Indonesia",
                        ),
                      ),

                      DropdownMenuItem(
                        value: "Malaysia",
                        child: Text(
                          "Malaysia",
                        ),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        selectedCountry =
                            value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // BUTTON
              // =========================
              Center(
                child: SizedBox(
                  width: 244,
                  height: 48,

                  child: ElevatedButton(
                    onPressed: () {},

                    style:
                        ElevatedButton.styleFrom(
                      elevation: 0,

                      backgroundColor:
                          Colors
                              .transparent,

                      shadowColor:
                          Colors
                              .transparent,

                      padding:
                          EdgeInsets.zero,
                    ),

                    child: Ink(
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),

                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                              0xFF006D37,
                            ),

                            Color(
                              0xFF27AE60,
                            ),
                          ],
                        ),
                      ),

                      child: const Center(
                        child: Text(
                          "Save Login",

                          style:
                              TextStyle(
                            fontSize:
                                16,

                            fontWeight:
                                FontWeight
                                    .w600,

                            color: Colors
                                .white,
                          ),
                        ),
                      ),
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
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // =========================
  // INPUT
  // =========================
  Widget _inputField({
    required TextEditingController
        controller,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,

      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            6,
          ),

          borderSide: BorderSide(
            color:
                Colors.black.withOpacity(
              0.14,
            ),
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            6,
          ),

          borderSide: BorderSide(
            color:
                Colors.black.withOpacity(
              0.14,
            ),
          ),
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

      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        border: Border.all(
          color:
              Colors.black.withOpacity(
            0.14,
          ),
        ),

        borderRadius:
            BorderRadius.circular(6),
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              text,

              style: const TextStyle(
                fontSize: 14,
                color: Color(
                  0xFF544C4C,
                ),
              ),
            ),
          ),

          const Icon(
            Icons.keyboard_arrow_down,
          ),
        ],
      ),
    );
  }
}