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
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SpaceHeight(100),
                Text(
                  'DAFTAR AKUN GALONGO',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(30),
                CustomTextField(
                  controller: nameController,
                  label: 'Nama Lengkap',
                  validator: 'Nama tidak boleh kosong',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                const SpaceHeight(20),
                CustomTextField(
                  controller: usernameController,
                  label: 'Username',
                  validator: 'Username tidak boleh kosong',
                  prefixIcon: const Icon(Icons.account_circle),
                ),
                const SpaceHeight(20),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: 'Email tidak boleh kosong',
                  prefixIcon: const Icon(Icons.email),
                ),
                const SpaceHeight(20),
                CustomTextField(
                  controller: phoneController,
                  label: 'Nomor HP',
                  validator: 'Nomor HP tidak boleh kosong',
                  prefixIcon: const Icon(Icons.phone),
                ),
                const SpaceHeight(20),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  validator: 'Password tidak boleh kosong',
                  obscureText: !isShowPassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isShowPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                      });
                    },
                  ),
                ),
                const SpaceHeight(40),
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
                    return ElevatedButton(
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
                                  roleId: 2, // Role 2 untuk Buyer, sesuaikan jika perlu
                                );

                                context.read<RegisterBloc>().add(
                                      RegisterRequested(requestModel: request),
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        state is RegisterLoading ? 'Memuat...' : 'Daftar',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
                const SpaceHeight(20),
                Text.rich(
                  TextSpan(
                    text: 'Sudah punya akun? ',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login di sini!',
                        style: TextStyle(color: AppColors.primary),
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
        ),
      ),
    );
  }
}
