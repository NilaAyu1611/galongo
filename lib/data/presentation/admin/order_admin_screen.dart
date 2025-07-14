import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/model/response/customer/order_response_model.dart';
import 'package:galongo/data/presentation/customer/home/orders/orders_bloc.dart';

class OrderAdminScreen extends StatelessWidget {
  const OrderAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Muat semua pesanan customer untuk admin
    context.read<OrdersBloc>().add(LoadAllCustomerOrders());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pesanan Pelanggan"),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersInitial || state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersLoadSuccess) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(child: Text("Belum ada pesanan."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final customerName = order.customer?.user?.name ?? 'Tidak diketahui';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(customerName.substring(0, 1).toUpperCase()),
                    ),
                    title: Text("Pesanan #${order.id} - ${order.status}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nama Customer: $customerName"),
                        Text("Jumlah: ${order.quantity} galon"),
                        Text("Total: Rp ${order.totalPrice}"),
                      ],
                    ),
                    trailing: const Icon(Icons.receipt_long, color: AppColors.primary),
                  ),
                );
              },
            );
          } else if (state is OrdersFailure) {
            return Center(child: Text("❌ Gagal memuat pesanan: ${state.message}"));
          } else {
            return const Center(child: Text("Tidak ada data."));
          }
        },
      ),
    );
  }
}
