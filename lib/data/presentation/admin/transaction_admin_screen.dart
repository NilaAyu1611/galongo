import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/customer/home/transactions/transaction_bloc.dart';


class TransactionAdminScreen extends StatelessWidget {
  const TransactionAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load data
    context.read<TransactionBloc>()
      ..add(LoadTransactions())
      ..add(LoadTransactionSummary());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi Pelanggan"),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoadSuccess) {
            final transactions = state.transactions;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Card(
                  child: ListTile(
                    title: Text("Rp ${tx.amount} - ${tx.type}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Deskripsi: ${tx.description ?? '-'}"),
                        Text("Customer: ${tx.customerName ?? 'Tanpa nama'}"),
                        Text("Waktu: ${tx.createdAt ?? '-'}"),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TransactionSummarySuccess) {
            return Column(
              children: [
                const Text("Ringkasan Transaksi"),
                Text("Total Masuk: Rp ${state.summary.totalIn}"),
                Text("Total Keluar: Rp ${state.summary.totalOut}"),
                Text("Saldo Bersih: Rp ${state.summary.netBalance}"),
              ],
            );
          } else if (state is TransactionFailure) {
            return Center(child: Text("Gagal: ${state.message}"));
          } else {
            return const Center(child: Text("Tidak ada data"));
          }
        },
      ),
    );
  }
}
