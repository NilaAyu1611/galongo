import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:galongo/core/components/custom_text_field.dart';
import 'package:galongo/core/components/spaces.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/model/request/auth/register_request_model.dart';
import 'package:galongo/data/presentation/auth/bloc/register/register_bloc.dart';
import 'package:galongo/data/presentation/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController nameController;
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> _formKey;
  bool isShowPassword = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0078D4), Color(0xFF00B4DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              const Icon(Icons.person_add_alt_1, size: 80, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                'Daftar Akun Galongo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Isi datamu untuk membuat akun',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: nameController,
                        label: 'Nama Lengkap',
                        validator: 'Nama tidak boleh kosong',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      const SpaceHeight(16),
                      CustomTextField(
                        controller: usernameController,
                        label: 'Username',
                        validator: 'Username tidak boleh kosong',
                        prefixIcon: const Icon(Icons.account_circle),
                      ),
                      const SpaceHeight(16),
                      CustomTextField(
                        controller: emailController,
                        label: 'Email',
                        validator: 'Email tidak boleh kosong',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      const SpaceHeight(16),
                      CustomTextField(
                        controller: phoneController,
                        label: 'Nomor HP',
                        validator: 'Nomor HP tidak boleh kosong',
                        prefixIcon: const Icon(Icons.phone_android),
                      ),
                      const SpaceHeight(16),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        validator: 'Password tidak boleh kosong',
                        obscureText: !isShowPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isShowPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isShowPassword = !isShowPassword;
                            });
                          },
                        ),
                      ),
                      const SpaceHeight(30),
                      BlocConsumer<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          } else if (state is RegisterFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: AppColors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: state is RegisterLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        final request = RegisterRequestModel(
                                          name: nameController.text,
                                          username: usernameController.text,
                                          email: emailController.text,
                                          phone: phoneController.text,
                                          password: passwordController.text,
                                          roleId: 2,
                                        );
                                        context.read<RegisterBloc>().add(
                                              RegisterRequested(requestModel: request),
                                            );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0078D4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                state is RegisterLoading ? 'Memuat...' : 'Daftar',
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                      const SpaceHeight(20),
                      Text.rich(
                        TextSpan(
                          text: 'Sudah punya akun? ',
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(
                              text: 'Login di sini!',
                              style: const TextStyle(
                                color: Color(0xFF0078D4),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
