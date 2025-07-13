import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/model/request/admin/stock_request_model.dart';
import 'package:galongo/data/presentation/admin/stock/stock_bloc.dart';


class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final request = StockRequestModel(
        quantity: int.tryParse(quantityController.text),
        price: int.tryParse(priceController.text),
        image: imageController.text,
      );

      context.read<StockBloc>().add(AddStock(request: request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Stok"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<StockBloc, StockState>(
          listener: (context, state) {
            if (state is StockAddSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Stok berhasil ditambahkan!')),
              );
              Navigator.pop(context); // kembali ke halaman sebelumnya
            } else if (state is StockFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('❌ ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: "Jumlah Galon"),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Jumlah tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Harga (Rp)"),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Harga tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: "Nama File Gambar (cth: galon1.png)"),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Gambar tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is StockLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      state is StockLoading ? "Menyimpan..." : "Simpan",
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
