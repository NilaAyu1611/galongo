import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/customer/home/transactions/transaction_bloc.dart';

class TransactionAdminScreen extends StatelessWidget {
  const TransactionAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TransactionBloc>().add(LoadAllTransactionData());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Transaksi Pelanggan"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionFailure) {
            return Center(child: Text("Gagal: ${state.message}"));
          }

          if (state is TransactionAllLoaded) {
            final transactions = state.transactions;
            final summary = state.summary;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ringkasan Transaksi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildSummaryCard("Total Masuk", summary.totalIn.toInt(), Colors.green, Icons.arrow_downward),
                      _buildSummaryCard("Total Keluar", summary.totalOut.toInt(), Colors.red, Icons.arrow_upward),
                      _buildSummaryCard("Saldo Bersih", summary.netBalance.toInt(), Colors.blue, Icons.account_balance_wallet),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Daftar Transaksi",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  ...transactions.map(
                    (tx) => Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rp ${_formatCurrency(tx.amount?.toInt() ?? 0)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: tx.type == 'IN' ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Deskripsi: ${tx.description ?? '-'}", style: const TextStyle(color: Colors.black87)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Customer: ${tx.customerName ?? 'Tanpa nama'}", style: const TextStyle(color: Colors.black87)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Waktu: ${tx.createdAt ?? '-'}", style: const TextStyle(color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("Tidak ada data"));
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, int amount, Color color, IconData icon) {
    return Container(
      width: 170,
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${_formatCurrency(amount)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
