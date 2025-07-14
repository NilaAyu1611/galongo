import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/admin/promo/promo_bloc.dart';
import 'package:intl/intl.dart';
import 'package:galongo/data/model/request/admin/promo_request_model.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _discountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<int> _selectedStockIds = [];

  @override
  void initState() {
    super.initState();
    context.read<PromoBloc>().add(FetchPromoList());
  }

  void _submitPromo() {
    final promo = PromoRequestModel(
      title: _titleController.text,
      description: _descController.text,
      discountPercentage: int.tryParse(_discountController.text),
      startDate: _startDate,
      endDate: _endDate,
      stockIds: _selectedStockIds,
    );

    context.read<PromoBloc>().add(SubmitPromo(promo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Promo')),
      body: BlocConsumer<PromoBloc, PromoState>(
        listener: (context, state) {
          if (state is PromoSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is PromoFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is PromoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Judul'),
                TextField(controller: _titleController),
                const SizedBox(height: 10),
                const Text('Deskripsi'),
                TextField(controller: _descController),
                const SizedBox(height: 10),
                const Text('Diskon (%)'),
                TextField(controller: _discountController, keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _startDate = picked);
                        },
                        child: Text(_startDate == null
                            ? 'Tanggal Mulai'
                            : DateFormat.yMd().format(_startDate!)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _endDate = picked);
                        },
                        child: Text(_endDate == null
                            ? 'Tanggal Berakhir'
                            : DateFormat.yMd().format(_endDate!)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitPromo,
                  child: const Text('Kirim Promo'),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const Text('Daftar Promo Aktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (state is PromoListLoaded)
                  ...state.promos.map((p) => Card(
                        child: ListTile(
                          title: Text(p['title'] ?? '-'),
                          subtitle: Text(p['description'] ?? ''),
                          trailing: Text("${p['discount_percentage']}%"),
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}