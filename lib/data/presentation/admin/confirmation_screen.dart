import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/model/request/admin/confirmation_request_mode.dart';
import 'package:galongo/data/presentation/admin/confirmation/confirmation_bloc.dart';

class ConfirmationScreen extends StatefulWidget {
  final int orderId;

  const ConfirmationScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfirmasi Pesanan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ConfirmationBloc, ConfirmationState>(
          listener: (context, state) {
            if (state is ConfirmationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pop(context);
            } else if (state is ConfirmationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Catatan (Opsional):"),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tulis catatan tambahan...'
                  ),
                ),
                const SizedBox(height: 24),
                state is ConfirmationLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final request = ConfirmationRequestModel(
                              orderId: widget.orderId,
                              confirmedAt: DateTime.now(),
                              notes: _notesController.text,
                            );
                            context.read<ConfirmationBloc>().add(SubmitConfirmation(request));
                          },
                          child: const Text("Konfirmasi Pesanan"),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
