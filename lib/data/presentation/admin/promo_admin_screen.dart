import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/presentation/admin/promo/promo_bloc.dart';

class AdminPromoScreen extends StatelessWidget {
  const AdminPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Promo')),
      body: BlocBuilder<PromoBloc, PromoState>(
        builder: (context, state) {
          if (state is PromoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PromoLoadSuccess) {
            final promos = state.promos;
            return ListView.builder(
              itemCount: promos.length,
              itemBuilder: (context, index) {
                final promo = promos[index];
                return ListTile(
                  title: Text(promo['title']),
                  subtitle: Text("${promo['discount_percentage']}%"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // TODO: Edit promo
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<PromoBloc>().add(DeletePromo(promo['id']));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is PromoFailure) {
            return Center(child: Text("❌ ${state.message}"));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Buka form tambah promo
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
