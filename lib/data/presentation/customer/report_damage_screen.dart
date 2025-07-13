import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/customer/home/report_damage/report_damage_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:galongo/data/presentation/customer/report_damage/bloc/report_damage_bloc.dart';

class ReportDamageScreen extends StatefulWidget {
  final int orderId;
  const ReportDamageScreen({super.key, required this.orderId});

  @override
  State<ReportDamageScreen> createState() => _ReportDamageScreenState();
}

class _ReportDamageScreenState extends State<ReportDamageScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitReport() {
    if (_imageFile == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi foto dan deskripsi")),
      );
      return;
    }

    final bytes = _imageFile!.readAsBytesSync();
    final base64Image = base64Encode(bytes);

    context.read<ReportDamageBloc>().add(
      SubmitDamageReport(
        orderId: widget.orderId,
        description: _descriptionController.text,
        photoBase64: base64Image,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Kerusakan")),
      body: BlocConsumer<ReportDamageBloc, ReportDamageState>(
        listener: (context, state) {
          if (state is ReportDamageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is ReportDamageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi kerusakan",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _imageFile != null
                    ? Image.file(_imageFile!, height: 150)
                    : const Text("Belum ada foto"),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Ambil Foto"),
                ),
                const Spacer(),
                state is ReportDamageLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitReport,
                        child: const Text("Kirim Laporan"),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
