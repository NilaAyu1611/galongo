import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/admin/stock/stock_bloc.dart';
import 'package:galongo/data/presentation/admin/stock_screen.dart';
import 'package:galongo/data/presentation/auth/login_screen.dart';
import 'package:galongo/data/presentation/auth/register_screen.dart';
import 'package:galongo/data/presentation/admin/admin_home_screen.dart';
import 'package:galongo/data/presentation/customer/home/customer_home_screen.dart';
import 'package:galongo/data/presentation/admin/dashboard/dashboard_bloc.dart';
import 'package:galongo/data/repository/dashboard_repository.dart';
import 'package:galongo/data/repository/stock_repository.dart';
import 'package:galongo/services/service_http_client.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/admin-home': (context) => BlocProvider(
      create: (_) => DashboardBloc(
        dashboardRepository: DashboardRepository(ServiceHttpClient()),
      )..add(LoadDashboard()),
      child: const AdminHomeScreen(),
    ),
    '/stock': (context) => BlocProvider(
        create: (context) => StockBloc(stockRepository: StockRepository(ServiceHttpClient())),
        child: const StockScreen(),
      ),

    '/customer-home': (context) => const CustomerHomeScreen(),
  };
}
