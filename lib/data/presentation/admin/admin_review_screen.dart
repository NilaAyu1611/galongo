import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/presentation/customer/home/review/review_bloc.dart';

class AdminReviewScreen extends StatelessWidget {
  const AdminReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ReviewBloc>().add(LoadReviews());

    return Scaffold(
      appBar: AppBar(title: const Text("Ulasan Pelanggan")),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewLoadSuccess) {
            final reviews = state.reviews;
            if (reviews.isEmpty) {
              return const Center(child: Text("Belum ada ulasan."));
            }
            return ListView.builder(
              itemCount: reviews.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final r = reviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text("Rating: ${r["rating"]}"),
                    subtitle: Text("${r["comment"]}"),
                    trailing: Text("Order #${r["order_id"]}"),
                  ),
                );
              },
            );
          } else if (state is ReviewFailure) {
            return Center(child: Text("Gagal memuat: ${state.error}"));
          }
          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }
}
