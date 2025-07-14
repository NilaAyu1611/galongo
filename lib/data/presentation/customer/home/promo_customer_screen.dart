import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/presentation/admin/promo/promo_bloc.dart';

class PromoCustomerScreen extends StatelessWidget {
  const PromoCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PromoBloc>().add(LoadPromos());

    return Scaffold(
      appBar: AppBar(title: const Text("Promo Tersedia"), backgroundColor: AppColors.primary),
      body: BlocBuilder<PromoBloc, PromoState>(
        builder: (context, state) {
          if (state is PromoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PromoLoadSuccess) {
            return ListView.builder(
              itemCount: state.promos.length,
              itemBuilder: (context, index) {
                final promo = state.promos[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(promo['title'] ?? '-'),
                    subtitle: Text(promo['description'] ?? '-'),
                    trailing: Text("Diskon: ${promo['discount_percentage']}%"),
                  ),
                );
              },
            );
          } else if (state is PromoFailure) {
            return Center(child: Text("Gagal memuat promo: ${state.message}"));
          }
          return const Center(child: Text("Tidak ada promo."));
        },
      ),
    );
  }
}
