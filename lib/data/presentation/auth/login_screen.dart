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
import 'package:galongo/data/presentation/customer/home/customer_home_screen.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SpaceHeight(150),
                Text(
                  'Selamat Datang di Galongo!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(30),
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
                      color: AppColors.grey,
                    ),
                  ),
                ),
                const SpaceHeight(30),
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
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Role tidak dikenal')),
        );
      }
    }
  

                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is LoginLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final request = LoginRequestModel(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                );
                                context.read<LoginBloc>().add(LoginRequested(requestModel: request));
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        state is LoginLoading ? 'Memuat...' : 'Masuk',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
                const SpaceHeight(20),
                Text.rich(
                  TextSpan(
                    text: 'Belum punya akun? ',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                    children: [
                      TextSpan(
                        text: 'Daftar di sini!',
                        style: TextStyle(color: AppColors.primary),
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
      ),
    );
  }
}
