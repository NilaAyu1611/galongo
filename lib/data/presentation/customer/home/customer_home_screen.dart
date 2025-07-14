import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/presentation/admin/stock/stock_bloc.dart';
import 'package:galongo/data/model/response/stock_list_response_model.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StockBloc>().add(LoadAllStock());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Galongo - Galon"),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: BlocBuilder<StockBloc, StockState>(
          builder: (context, state) {
            if (state is StockLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockLoadSuccess) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 16),
                  _buildBannerPromo(),
                  const SizedBox(height: 16),
                  _buildSaldoKoin(),
                  const SizedBox(height: 16),
                  const Text("Kategori Galon", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildKategoriGalon(),
                  const SizedBox(height: 20),
                  const Text("Produk Galon", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildProdukList(state.stockList),
                ],
              );
            } else if (state is StockFailure) {
              return Center(child: Text("❌ ${state.message}"));
            } else {
              return const Center(child: Text("Data tidak tersedia."));
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Row(
      children: const [
        Icon(Icons.location_on, color: Colors.blue),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dikirim ke", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Jl. Nanas No.30, Kos Abadi", style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildBannerPromo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        "assets/images/banner_gratis_ongkir.jpg",
        height: 140,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100),
      ),
    );
  }

  Widget _buildSaldoKoin() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: AppColors.primary),
              title: const Text("Rp0", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Saldo Anda"),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.local_drink, color: Colors.lightBlue),
              title: const Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Poin Galon"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriGalon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _KategoriItem(title: "Galon Isi", icon: Icons.water_drop),
        _KategoriItem(title: "Galon + Botol", icon: Icons.local_drink),
        _KategoriItem(title: "Botol Kosong", icon: Icons.recycling),
      ],
    );
  }

  Widget _buildProdukList(List<StockData> stocks) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          final stock = stocks[index];
          final image = stock.image ?? 'placeholder.png';

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(right: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/$image',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp ${stock.price}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "${stock.quantity} pcs",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primary),
                    tooltip: "Pesan galon ini",
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/order', // pastikan route ini sudah ada di main.dart
                        arguments: stock,
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _KategoriItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const _KategoriItem({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.lightBlue.shade100,
          radius: 25,
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
