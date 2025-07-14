import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/customer/home/report_damage/report_damage_bloc.dart';

class AdminReportDamageScreen extends StatelessWidget {
  const AdminReportDamageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ReportDamageBloc>().add(LoadDamageReports());

    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Kerusakan")),
      body: BlocBuilder<ReportDamageBloc, ReportDamageState>(
        builder: (context, state) {
          if (state is ReportDamageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportDamageLoadSuccess) {
            final reports = state.reports;
            if (reports.isEmpty) {
              return const Center(child: Text("Belum ada laporan."));
            }
            return ListView.builder(
              itemCount: reports.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final r = reports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text("Order ID: ${r["order_id"]}"),
                    subtitle: Text(r["description"] ?? "-"),
                    trailing: Text(r["status"] ?? "pending"),
                  ),
                );
              },
            );
          } else if (state is ReportDamageFailure) {
            return Center(child: Text("Gagal memuat: ${state.error}"));
          }
          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }
}
