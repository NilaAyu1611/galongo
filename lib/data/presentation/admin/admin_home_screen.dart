import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/core/utils/storage_helper.dart';
import 'package:galongo/data/presentation/admin/admin_report_damage_screen.dart';
import 'package:galongo/data/presentation/admin/confirmation_screen.dart';
import 'package:galongo/data/presentation/admin/dashboard/dashboard_bloc.dart';
import 'package:galongo/data/presentation/admin/order_admin_screen.dart';
import 'package:galongo/data/presentation/admin/promo_admin_screen.dart';
import 'package:galongo/data/presentation/admin/stock_screen.dart';
import 'package:galongo/data/presentation/admin/transaction_admin_screen.dart';
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
          backgroundColor: const Color(0xFFF7F9FC),
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
                        leading: Icon(
                          _menuIcons[index],
                          color: _selectedIndex == index ? AppColors.primary : Colors.grey,
                        ),
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
        return const TransactionAdminScreen();
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
            {'x': 3, 'label': 'Delivered', 'value': data?.delivered ?? 0, 'color': const Color(0xFF3A0CA3)},
            {'x': 4, 'label': 'Received', 'value': data?.received ?? 0, 'color': Colors.orange},
            {'x': 5, 'label': 'Rating', 'value': (data?.averageRating ?? 0).toDouble(), 'color': Colors.red},
          ];

          double getRoundedMaxY(double value) {
            if (value <= 10) return 10;
            if (value <= 50) return (value / 10).ceil() * 10;
            if (value <= 100) return (value / 20).ceil() * 20;
            if (value <= 500) return (value / 50).ceil() * 50;
            return (value / 100).ceil() * 100;
          }

          double getYAxisInterval(double maxY) {
            if (maxY <= 10) return 2;
            if (maxY <= 50) return 5;
            if (maxY <= 100) return 10;
            if (maxY <= 500) return 50;
            return 100;
          }

          final rawMaxY = barData.map((e) => (e['value'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
          final maxYValue = getRoundedMaxY(rawMaxY);
          final yInterval = getYAxisInterval(maxYValue);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Progress Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
                    ],
                  ),
                  child: BarChart(
                    BarChartData(
                      maxY: maxYValue,
                      barGroups: barData.map((item) {
                        final value = (item['value'] as num).toDouble();
                        return BarChartGroupData(
                          x: item['x'] as int,
                          barRods: [
                            BarChartRodData(
                              toY: value,
                              width: 20,
                              color: item['color'] as Color,
                              borderRadius: BorderRadius.circular(6),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: maxYValue,
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),
                          ],
                          showingTooltipIndicators: [0],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return Icon(Icons.list_alt, size: 18, color: Colors.deepPurple);
                                case 1:
                                  return Icon(Icons.schedule, size: 18, color: Colors.blue);
                                case 2:
                                  return Icon(Icons.check_circle_outline, size: 18, color: Colors.green);
                                case 3:
                                  return Icon(Icons.local_shipping, size: 18, color: Color(0xFF3A0CA3));
                                case 4:
                                  return Icon(Icons.inventory_2, size: 18, color: Colors.orange);
                                case 5:
                                  return Icon(Icons.star, size: 18, color: Colors.red);
                                default:
                                  return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: yInterval,
                            getTitlesWidget: (value, _) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                            reservedSize: 30,
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        horizontalInterval: yInterval,
                        getDrawingHorizontalLine: (value) =>
                            FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.black87,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY}',
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildStatCard('Total Order', data?.totalOrder?.toString()),
                _buildStatCard('Pending', data?.pending?.toString()),
                _buildStatCard('Confirmed', data?.confirmed?.toString()),
                _buildStatCard('Delivered', data?.delivered?.toString()),
                _buildStatCard('Received', data?.received?.toString()),
                _buildStatCard('Average Rating', data?.averageRating?.toStringAsFixed(1)),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStatCard(String title, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value ?? '-', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
