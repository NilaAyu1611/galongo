import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/core/utils/storage_helper.dart';
import 'package:galongo/data/presentation/admin/admin_report_damage_screen.dart';
import 'package:galongo/data/presentation/admin/confirmation_screen.dart';
import 'package:galongo/data/presentation/admin/dashboard/dashboard_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:galongo/data/presentation/admin/order_admin_screen.dart';
import 'package:galongo/data/presentation/admin/promo_admin_screen.dart';
import 'package:galongo/data/presentation/admin/stock_screen.dart';
import 'package:galongo/data/presentation/customer/transaction_customer_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  final List<String> _menuTitles = [
    'Dashboard',
    'Stock',
    'Orders',
    'Report',
    'Confirmation',
    'Transaction',
    'Daftar Customer',
    'Promo'
  ];

  final List<IconData> _menuIcons = [
    Icons.dashboard,
    Icons.storage,
    Icons.list_alt,
    Icons.insert_chart,
    Icons.check_circle_outline,
    Icons.payment,
    Icons.people,
    Icons.campaign,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(LoadDashboard());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: StorageHelper.getName(),
      builder: (context, snapshot) {
        final userName = snapshot.data ?? '-';

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(_menuTitles[_selectedIndex]),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await StorageHelper.clearAll();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: AppColors.primary),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/foto.jpg'),
                  ),
                  accountName: Text(userName),
                  accountEmail: const Text('Admin Galongo'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuTitles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(_menuIcons[index], color: _selectedIndex == index ? AppColors.primary : Colors.grey),
                        title: Text(_menuTitles[index]),
                        selected: _selectedIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: _buildBodyByIndex(),
        );
      },
    );
  }

 Widget _buildBodyByIndex() {
  switch (_selectedIndex) {
    case 0:
      return _buildDashboard();
    case 1:
      return const StockScreen();
    case 2:
      return const OrderAdminScreen();
    case 3:
      return const AdminReportDamageScreen();
    case 4:
       return ConfirmationScreen(orderId: 1);
    case 5:
      return const TransactionCustomerScreen(); // gunakan admin screen kalau ada
    case 6:
      return const OrderAdminScreen();
    case 7:
      return const AdminPromoScreen();
    default:
      return Center(
        child: Text(
          '${_menuTitles[_selectedIndex]} belum tersedia',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
  }
}



  Widget _buildDashboard() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardFailure) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is DashboardSuccess) {
          final data = state.dashboard.data;

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
                      _buildStatCard('Average Rating', data?.averageRating?.toStringAsFixed(1)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
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
