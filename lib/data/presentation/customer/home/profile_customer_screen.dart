import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/model/request/customer/customer_profile_request_model.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/presentation/customer/home/profile_customer/profile_customer_bloc.dart';

class ProfileCustomerScreen extends StatefulWidget {
  const ProfileCustomerScreen({super.key});

  @override
  State<ProfileCustomerScreen> createState() => _ProfileCustomerScreenState();
}

class _ProfileCustomerScreenState extends State<ProfileCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCustomerBloc>().add(LoadCustomerProfile());
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = CustomerProfileRequestModel(
        name: _nameCtrl.text,
        phone: _phoneCtrl.text,
        address: _addressCtrl.text,
      );

      context.read<ProfileCustomerBloc>().add(UpdateCustomerProfile(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: AppColors.primary,
      ),
      body: BlocConsumer<ProfileCustomerBloc, ProfileCustomerState>(
        listener: (context, state) {
          if (state is ProfileCustomerUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProfileCustomerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileCustomerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileCustomerLoaded) {
            final data = state.profile.data;
            _nameCtrl.text = data?.name ?? "";
            _phoneCtrl.text = data?.phone ?? "";
            _addressCtrl.text = data?.address ?? "";

            return _buildForm();
          } else if (state is ProfileCustomerInitial) {
            return _buildForm();
          } else {
            return const Center(child: Text("Gagal memuat data profil."));
          }
        },
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: _addressCtrl,
              decoration: const InputDecoration(labelText: 'Alamat'),
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
