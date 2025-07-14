import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/model/request/customer/report_damage_request_model.dart';
import 'package:galongo/data/presentation/customer/home/report_damage/report_damage_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CustomerReportDamageScreen extends StatefulWidget {
  final int orderId;
  const CustomerReportDamageScreen({super.key, required this.orderId});

  @override
  State<CustomerReportDamageScreen> createState() => _CustomerReportDamageScreenState();
}

class _CustomerReportDamageScreenState extends State<CustomerReportDamageScreen> {
  final _descriptionController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Kerusakan")),
      body: BlocConsumer<ReportDamageBloc, ReportDamageState>(
        listener: (context, state) {
          if (state is ReportDamageSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is ReportDamageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Gagal: ${state.error}")),
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
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: "Deskripsi", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Ambil Foto"),
                ),
                if (_selectedImage != null) Image.file(_selectedImage!, height: 100),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state is ReportDamageLoading
                      ? null
                      : () {
                          context.read<ReportDamageBloc>().add(
                                SubmitDamageReport(
                                  ReportDamageRequestModel(
                                    orderId: widget.orderId,
                                    description: _descriptionController.text,
                                    photo: _selectedImage?.path, // untuk sementara path saja
                                  ),
                                ),
                              );
                        },
                  child: const Text("Kirim Laporan"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}