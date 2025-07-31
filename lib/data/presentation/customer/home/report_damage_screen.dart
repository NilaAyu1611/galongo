import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:galongo/data/model/request/customer/report_damage_request_model.dart';
import 'package:galongo/data/presentation/customer/home/report_damage/report_damage_bloc.dart';

class ReportDamageScreen extends StatefulWidget {
  const ReportDamageScreen({super.key});

  @override
  State<ReportDamageScreen> createState() => _ReportDamageScreenState();
}

class _ReportDamageScreenState extends State<ReportDamageScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  int? _selectedOrderId; // bisa diganti pakai dropdown order
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitReport() {
    if (_selectedOrderId == null || _descriptionController.text.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📌 Lengkapi semua field terlebih dahulu')),
      );
      return;
    }

    final bytes = _imageFile!.readAsBytesSync();
    final base64Image = base64Encode(bytes);

    final request = ReportDamageRequestModel(
      orderId: _selectedOrderId,
      description: _descriptionController.text,
      photo: base64Image,
    );

    // context.read<ReportDamageBloc>().add(SubmitDamageReport(request));
    context.read<ReportDamageBloc>().add(SubmitDamageReport(request, _imageFile!));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporkan Kerusakan')),
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
            child: ListView(
              children: [
                const Text("Order ID", style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _selectedOrderId = int.tryParse(val),
                  decoration: const InputDecoration(hintText: 'Masukkan ID Pesanan'),
                ),
                const SizedBox(height: 12),
                const Text("Deskripsi Kerusakan", style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Contoh: Galon bocor di bagian bawah'),
                ),
                const SizedBox(height: 12),
                const Text("Foto Kerusakan", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _imageFile != null
                    ? Image.file(_imageFile!, height: 200)
                    : const Text("📷 Belum ada foto"),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Ambil Foto dari Kamera"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state is ReportDamageLoading ? null : _submitReport,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: state is ReportDamageLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Kirim Laporan"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
