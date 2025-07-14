import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/customer/home/transactions/transaction_bloc.dart';


class TransactionCustomerScreen extends StatelessWidget {
  const TransactionCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TransactionBloc>().add(LoadTransactions());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi Saya"),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoadSuccess) {
            final transactions = state.transactions;

            if (transactions.isEmpty) {
              return const Center(child: Text("Belum ada transaksi."));
            }

            return ListView.builder(
              itemCount: transactions.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Card(
                  child: ListTile(
                    title: Text("Rp ${tx.amount} - ${tx.type}"),
                    subtitle: Text(tx.description ?? ''),
                    trailing: Text(tx.createdAt ?? ''),
                  ),
                );
              },
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
