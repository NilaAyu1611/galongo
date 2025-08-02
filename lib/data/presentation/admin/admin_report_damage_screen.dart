import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/customer/home/report_damage/report_damage_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class AdminReportDamageScreen extends StatefulWidget {
  const AdminReportDamageScreen({super.key});

  @override
  State<AdminReportDamageScreen> createState() => _AdminReportDamageScreenState();
}

class _AdminReportDamageScreenState extends State<AdminReportDamageScreen> {
  final Map<int, String> statusUpdates = {};
  final Map<int, bool> isLoadingButton = {}; // untuk loading di tombol simpan

  @override
  void initState() {
    super.initState();
    context.read<ReportDamageBloc>().add(LoadDamageReports());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "reviewed":
        return Colors.blue;
      case "resolved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.hourglass_empty;
      case "reviewed":
        return Icons.search;
      case "resolved":
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  void _showSnackbar(BuildContext context, String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: PreferredSize(
  preferredSize: const Size.fromHeight(80),
  child: AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(top: 40, left: 20, right: 12),
      child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Center(
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: "📋 ",
                style: TextStyle(fontSize: 26),
              ),
              TextSpan(
                text: "Laporan Kerusakan",
                style: GoogleFonts.poppins( // gunakan font gaul
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
    IconButton(
      onPressed: () {
        context.read<ReportDamageBloc>().add(LoadDamageReports());
      },
      icon: const Icon(Icons.refresh, color: Colors.white),
      tooltip: "Muat ulang",
    ),
  ],
),



    ),
  ),
),

      backgroundColor: Colors.grey[100],
      body: BlocConsumer<ReportDamageBloc, ReportDamageState>(
        listener: (context, state) {
          if (state is ReportDamageSubmitSuccess) {
            _showSnackbar(context, state.message);
          } else if (state is ReportDamageFailure) {
            _showSnackbar(context, state.error, error: true);
          } else if (state is ReportDamageStatusUpdateSuccess) {
            _showSnackbar(context, state.message); // ✅ tampilkan snackbar saat update berhasil
          }
        },

        builder: (context, state) {
          if (state is ReportDamageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportDamageLoadSuccess) {
            final reports = state.reports;
            if (reports.isEmpty) {
              return const Center(child: Text("Belum ada laporan."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final r = reports[index];
                final selectedStatus = statusUpdates[index] ?? r["status"] ?? "pending";
                final isSaving = isLoadingButton[index] ?? false;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment, color: Colors.indigo),
                            const SizedBox(width: 8),
                            Text("Order ID: ${r["order_id"]}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.description, size: 20, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                r["description"] ?? "-",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(_getStatusIcon(selectedStatus), color: _getStatusColor(selectedStatus)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedStatus,
                                decoration: InputDecoration(
                                  labelText: "Status",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: const [
                                  DropdownMenuItem(value: "pending", child: Text("Pending")),
                                  DropdownMenuItem(value: "reviewed", child: Text("Reviewed")),
                                  DropdownMenuItem(value: "resolved", child: Text("Resolved")),
                                ],
                                onChanged: (newValue) {
                                  setState(() {
                                    statusUpdates[index] = newValue!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                icon: isSaving
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: Text(isSaving ? "Menyimpan..." : "Simpan"),
                                onPressed: isSaving
                                    ? null
                                    : () async {
                                        setState(() {
                                          isLoadingButton[index] = true;
                                        });

                                        context.read<ReportDamageBloc>().add(
                                              UpdateDamageReportStatus(
                                                id: r["id"],
                                                newStatus: selectedStatus,
                                              ),
                                            );

                                        // Delay untuk loading efek (opsional)
                                        await Future.delayed(const Duration(milliseconds: 1200));
                                        setState(() {
                                          isLoadingButton[index] = false;
                                        });
                                        
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ReportDamageFailure) {
            return Center(
              child: Text(
                "Gagal memuat: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }
}
