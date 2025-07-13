import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/core/utils/storage_helper.dart';
import 'package:galongo/data/presentation/admin/dashboard/dashboard_bloc.dart';


class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kirim event GetDashboard hanya sekali saat frame pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(LoadDashboard());
    });

    return FutureBuilder<String?>(
      future: StorageHelper.getName(), // Ambil nama dari StorageHelper
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userName = snapshot.data ?? '-';

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/foto.jpg'),
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Selamat Datang',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          Text(
                            userName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () async {
                      await StorageHelper.clearAll(); // Clear token dan data login
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'Stock'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            currentIndex: 0,
            onTap: (index) {
              // TODO: Implement page switching logic
            },
          ),
          body: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading || state is DashboardInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DashboardFailure) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is DashboardSuccess) {
                final data = state.dashboard.data;

                Text(data?.totalOrder?.toString() ?? '-');

                final barData = [
                  {'x': 0, 'label': 'Total', 'value': data?.totalOrder ?? 0, 'color': Colors.deepPurple},
                  {'x': 1, 'label': 'Pending', 'value': data?.pending ?? 0, 'color': Colors.blue},
                  {'x': 2, 'label': 'Confirmed', 'value': data?.confirmed ?? 0, 'color': Colors.green},
                  {'x': 3, 'label': 'Completed', 'value': data?.completed ?? 0, 'color': Colors.orange},
                  {'x': 4, 'label': 'Rating', 'value': (data?.averageRating ?? 0).toDouble(), 'color': Colors.red},
                ];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: const Text('Progress Overview',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BarChart(
                                BarChartData(
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(show: true),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: true),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final item = barData.firstWhere(
                                            (e) => e['x'] == value.toInt(),
                                            orElse: () => {'label': ''},
                                          );
                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            child: Text(item['label'].toString(),
                                                style: const TextStyle(fontSize: 10)),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  barGroups: barData.map((item) {
                                    return BarChartGroupData(
                                      x: item['x'] as int,
                                      barRods: [
                                        BarChartRodData(
                                          toY: (item['value'] as num).toDouble(),
                                          color: item['color'] as Color,
                                          width: 16,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildStatCard('Total Order', data?.totalOrder?.toString()),
                            _buildStatCard('Pending', data?.pending?.toString()),
                            _buildStatCard('Confirmed', data?.confirmed?.toString()),
                            _buildStatCard('Completed', data?.completed?.toString()),
                            _buildStatCard('Average Rating',
                                data?.averageRating?.toStringAsFixed(1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String? value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            Text(value ?? '-', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
