import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/components/custom_text_field.dart';
import 'package:galongo/core/components/spaces.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/model/request/auth/login_request_model.dart';
import 'package:galongo/data/presentation/admin/admin_home_screen.dart';
import 'package:galongo/data/presentation/auth/bloc/login/login_bloc.dart';
import 'package:galongo/data/presentation/auth/register_screen.dart';
import 'package:galongo/data/presentation/customer/main_customer_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> _formKey;
  bool isShowPassword = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0078D4),
              Color(0xFF00B4DB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.water_drop, size: 80, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                'Galongo Depot Air',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk untuk melanjutkan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 36),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: usernameController,
                        label: 'Username',
                        validator: 'Username tidak boleh kosong',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      const SpaceHeight(20),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        validator: 'Password tidak boleh kosong',
                        obscureText: !isShowPassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isShowPassword = !isShowPassword;
                            });
                          },
                          icon: Icon(
                            isShowPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)),
                            );
                          } else if (state is LoginSuccess) {
                            final role = state.responseModel.data?.role?.toLowerCase();
                            if (role == 'admin') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                              );
                            } else if (role == 'customer') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.responseModel.message ?? 'Login berhasil')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MainCustomerScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Role tidak dikenal')),
                              );
                            }
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: state is LoginLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        final request = LoginRequestModel(
                                          username: usernameController.text,
                                          password: passwordController.text,
                                        );
                                        context.read<LoginBloc>().add(
                                              LoginRequested(requestModel: request),
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
                                state is LoginLoading ? 'Memuat...' : 'Masuk',
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          text: 'Belum punya akun? ',
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(
                              text: 'Daftar di sini!',
                              style: const TextStyle(
                                color: Color(0xFF0078D4),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
