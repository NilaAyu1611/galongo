import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/bloc/transaction/transaction_bloc.dart';
import 'package:galongo/data/model/request/customer/transaction_request_model.dart';
import 'package:galongo/data/presentation/customer/home/transactions/transaction_bloc.dart';

class CustomerTransactionScreen extends StatefulWidget {
  const CustomerTransactionScreen({super.key});

  @override
  State<CustomerTransactionScreen> createState() => _CustomerTransactionScreenState();
}

class _CustomerTransactionScreenState extends State<CustomerTransactionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadAllTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaksi Saya")),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionFailure) {
            return Center(child: Text("❌ ${state.message}"));
          } else if (state is TransactionSuccess) {
            final transactions = state.transactions;
            if (transactions.isEmpty) {
              return const Center(child: Text("Belum ada transaksi."));
            }
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final trx = transactions[index];
                return ListTile(
                  leading: const Icon(Icons.receipt),
                  title: Text("Transaksi #${index + 1}"),
                  subtitle: Text(trx),
                );
              },
            );
          }
          return const Center(child: Text("Data tidak tersedia."));
        },
      ),
    );
  }
}
