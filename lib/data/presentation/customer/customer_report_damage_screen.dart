import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:galongo/data/model/request/customer/report_damage_request_model.dart';
import 'package:galongo/data/presentation/customer/home/report_damage/report_damage_bloc.dart';

class CustomerReportDamageScreen extends StatefulWidget {
  final int orderId;

  const CustomerReportDamageScreen({super.key, required this.orderId});

  @override
  State<CustomerReportDamageScreen> createState() => _CustomerReportDamageScreenState();
}

class _CustomerReportDamageScreenState extends State<CustomerReportDamageScreen> {
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate() || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📸 Lengkapi deskripsi dan ambil foto terlebih dahulu")),
      );
      return;
    }

    final request = ReportDamageRequestModel(
      orderId: widget.orderId,
      description: _descriptionController.text,
      photo: "", // Kosong karena akan dikirim lewat multipart
    );

    context.read<ReportDamageBloc>().add(
          SubmitDamageReport(request, _selectedImage!),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Kerusakan")),
      body: BlocConsumer<ReportDamageBloc, ReportDamageState>(
        listener: (context, state) {
          if (state is ReportDamageSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ ${state.message}")));
            Navigator.pop(context);
          } else if (state is ReportDamageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ ${state.error}")));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text("Deskripsi Kerusakan", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Contoh: Galon bocor di bagian bawah",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? "Deskripsi tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),
                  const Text("Foto Kerusakan", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _selectedImage != null
                      ? Image.file(_selectedImage!, height: 150)
                      : const Text("📷 Belum ada foto yang dipilih"),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Ambil Foto dari Kamera"),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is ReportDamageLoading ? null : _submitReport,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: state is ReportDamageLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Kirim Laporan"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
