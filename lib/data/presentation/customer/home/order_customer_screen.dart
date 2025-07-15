import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/customer/home/cart/cart_bloc.dart';
import 'package:galongo/data/presentation/customer/home/cart/cart_event.dart';
import 'package:galongo/data/presentation/customer/home/cart/cart_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:galongo/core/constants/colors.dart';

import 'package:galongo/data/model/response/customer/cart_response_model.dart';

class OrderCustomerScreen extends StatefulWidget {
  const OrderCustomerScreen({super.key});

  @override
  State<OrderCustomerScreen> createState() => _OrderCustomerScreenState();
}

class _OrderCustomerScreenState extends State<OrderCustomerScreen> {
  String? selectedAddress;
  LatLng? selectedLatLng;

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCartEvent());
  }

  void _selectLocation() async {
    final result = await Navigator.pushNamed(context, '/map');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedAddress = result['address'];
        selectedLatLng = result['latlng'];
      });
    }
  }

  void _submitOrder(List<CartItem> items, int totalPrice) {
    if (selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📍 Lokasi belum dipilih.")),
      );
      return;
    }

    // TODO: Kirim order ke backend dengan data cart + selectedLatLng
    // Misalnya menggunakan OrdersBloc atau OrderRepository

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Pesanan berhasil dibuat!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfirmasi Pesanan"),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoadSuccess) {
            final items = state.items;
            final total = state.totalPrice;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item.stock['name'] ?? 'Produk'),
                        subtitle: Text("Jumlah: ${item.quantity}"),
                        trailing: Text("Rp ${item.stock['price'] ?? 0}"),
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Total"),
                  trailing: Text("Rp $total"),
                ),
                ListTile(
                  title: const Text("Alamat Pengantaran"),
                  subtitle: Text(selectedAddress ?? 'Belum dipilih'),
                  trailing: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: _selectLocation,
                  ),
                ),
                if (selectedLatLng != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Koordinat: ${selectedLatLng!.latitude}, ${selectedLatLng!.longitude}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submitOrder(items, total),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text("Pesan Sekarang"),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CartFailure) {
            return Center(child: Text("❌ ${state.message}"));
          } else {
            return const Center(child: Text("Keranjang kosong."));
          }
        },
      ),
    );
  }
}
