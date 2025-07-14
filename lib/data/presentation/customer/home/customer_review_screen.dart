import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/model/request/customer/review_request_mode.dart';
import 'package:galongo/data/presentation/customer/home/review/review_bloc.dart';

class CustomerReviewScreen extends StatefulWidget {
  final int orderId;
  const CustomerReviewScreen({super.key, required this.orderId});

  @override
  State<CustomerReviewScreen> createState() => _CustomerReviewScreenState();
}

class _CustomerReviewScreenState extends State<CustomerReviewScreen> {
  final _commentController = TextEditingController();
  int _rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beri Ulasan")),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is ReviewFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Gagal: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Rating (1-5)"),
                Slider(
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: "$_rating",
                  value: _rating.toDouble(),
                  onChanged: (value) => setState(() => _rating = value.toInt()),
                ),
                const SizedBox(height: 12),
                const Text("Komentar"),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state is ReviewLoading
                      ? null
                      : () {
                          context.read<ReviewBloc>().add(
                                SubmitReview(
                                  ReviewRequestModel(
                                    orderId: widget.orderId,
                                    rating: _rating,
                                    comment: _commentController.text,
                                  ),
                                ),
                              );
                        },
                  child: const Text("Kirim Ulasan"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}