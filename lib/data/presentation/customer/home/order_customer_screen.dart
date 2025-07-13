import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/model/response/customer/order_response_model.dart';
import 'package:galongo/data/presentation/customer/home/orders/orders_bloc.dart';

class OrderCustomerScreen extends StatelessWidget {
  const OrderCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesanan Saya"),
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

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text("Pesanan #${order.id} - ${order.status}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text("Jumlah: ${order.quantity} galon"),
                        Text("Total: Rp ${order.totalPrice}"),
                      ],
                    ),
                    trailing: Icon(Icons.local_shipping, color: AppColors.primary),
                  ),
                );
              },
            );
          } else if (state is OrdersFailure) {
            return Center(child: Text("Gagal memuat pesanan: ${state.message}"));
          } else {
            return const Center(child: Text("Tidak ada data."));
          }
        },
      ),
    );
  }
}
