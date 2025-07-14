import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/model/response/stock_list_response_model.dart';
import 'package:galongo/data/presentation/admin/admin_report_damage_screen.dart';
import 'package:galongo/data/presentation/admin/admin_review_screen.dart';
import 'package:galongo/data/presentation/admin/confirmation/confirmation_bloc.dart';
import 'package:galongo/data/presentation/admin/confirmation_screen.dart';
import 'package:galongo/data/presentation/admin/order_admin_screen.dart';
import 'package:galongo/data/presentation/admin/promo_admin_screen.dart';
import 'package:galongo/data/presentation/admin/stock/stock_bloc.dart';
import 'package:galongo/data/presentation/admin/stock_screen.dart';
import 'package:galongo/data/presentation/auth/login_screen.dart';
import 'package:galongo/data/presentation/auth/register_screen.dart';
import 'package:galongo/data/presentation/admin/admin_home_screen.dart';
import 'package:galongo/data/presentation/customer/customer_report_damage_screen.dart';
import 'package:galongo/data/presentation/customer/home/customer_review_screen.dart';
import 'package:galongo/data/presentation/customer/transaction_customer_screen.dart';
import 'package:galongo/data/presentation/customer/home/customer_home_screen.dart';
import 'package:galongo/data/presentation/admin/dashboard/dashboard_bloc.dart';
import 'package:galongo/data/presentation/customer/home/order_customer_screen.dart';
import 'package:galongo/data/repository/confirmation_repository.dart';
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
      //'/customer/orders': (context) => const OrderCustomerScreen(),
      '/admin/orders': (context) => const OrderAdminScreen(),

      //'/order': (context) => const OrderCustomerScreen(),

    '/customer-home': (context) => const CustomerHomeScreen(),
    '/customer/transactions': (context) => const TransactionCustomerScreen(),
    
    '/admin/promo': (context) => const AdminPromoScreen(),
    '/customer/review': (context) => const CustomerReviewScreen(orderId: 0), // ganti orderId sesuai kebutuhan saat navigasi
    '/admin/reviews': (context) => const AdminReviewScreen(),
    '/customer/report-damage': (context) => const CustomerReportDamageScreen(orderId: 0), // orderId runtime
    '/admin/report-damages': (context) => const AdminReportDamageScreen(),

    '/admin/confirmation': (context) {
      final orderId = ModalRoute.of(context)!.settings.arguments as int;
      return BlocProvider(
        create: (_) => ConfirmationBloc(ConfirmationRepository(ServiceHttpClient())),
        child: ConfirmationScreen(orderId: orderId),
      );
    },
      '/order': (context) {
    final stock = ModalRoute.of(context)!.settings.arguments as StockData;
    return OrderCustomerScreen(stock: stock);
  },





  };
}
