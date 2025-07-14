import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/data/model/request/admin/stock_request_model.dart';
import 'package:galongo/data/model/response/stock_list_response_model.dart';
import 'package:galongo/data/presentation/admin/stock/stock_bloc.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final List<String> imageOptions = [
    'galon1.png',
    'galon1.jpeg',
    'galon3.jpg',
    'galon4.jpg',
    'galon5.jpg',
    'galon6.jpeg',
  ];
  String selectedImage = 'galon1.png';

  @override
  void initState() {
    super.initState();
    context.read<StockBloc>().add(LoadAllStock());
    
    print('📦 Fetching stock from: admin/stocks');

  }


  void _submitStock() {
    final quantity = int.tryParse(quantityController.text);
    final price = int.tryParse(priceController.text);

    if (quantity == null || price == null || selectedImage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Harap isi semua data dengan benar")),
      );
      return;
    }

    context.read<StockBloc>().add(
      AddStock(
        request: StockRequestModel(
          quantity: quantity,
          price: price,
          image: selectedImage,
        ),
      ),
    );
  }

  void _showEditDialog(StockData stock) {
    final TextEditingController editQuantityController =
        TextEditingController(text: stock.quantity.toString());
    final TextEditingController editPriceController =
        TextEditingController(text: stock.price.toString());
    String imageEdit = stock.image ?? imageOptions.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Stok'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editQuantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: editPriceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: imageEdit,
                  decoration: const InputDecoration(labelText: 'Gambar'),
                  items: imageOptions.map((img) {
                    return DropdownMenuItem<String>(
                      value: img,
                      child: Row(
                        children: [
                          Image.asset('assets/images/$img', width: 30, height: 30),
                          const SizedBox(width: 10),
                          Text(img),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    imageEdit = val!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                final qty = int.tryParse(editQuantityController.text);
                final price = int.tryParse(editPriceController.text);
                if (qty != null && price != null) {
                  context.read<StockBloc>().add(UpdateStock(
                        id: stock.id!,
                        request: StockRequestModel(
                          quantity: qty,
                          price: price,
                          image: imageEdit,
                        ),
                      ));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(int stockId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus stok ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Hapus"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<StockBloc>().add(DeleteStock(stockId));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Stok"),
        backgroundColor: AppColors.primary,
      ),
      body: BlocConsumer<StockBloc, StockState>(
        listener: (context, state) {
  if (state is StockAddSuccess || state is StockSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text((state as dynamic).message)),
    );
    context.read<StockBloc>().add(LoadAllStock());
    quantityController.clear();
    priceController.clear();
    setState(() {
      selectedImage = imageOptions.first;
    });
  } else if (state is StockFailure || state is StockError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ ${(state as dynamic).message}")),
    );
  }
},

        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // --- FORM TAMBAH STOCK ---
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("Tambah Stok Baru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: quantityController,
                          decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: priceController,
                          decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedImage,
                          decoration: const InputDecoration(labelText: 'Pilih Gambar', border: OutlineInputBorder()),
                          items: imageOptions.map((img) {
                            return DropdownMenuItem<String>(
                              value: img,
                              child: Row(
                                children: [
                                  Image.asset('assets/images/$img', width: 30, height: 30),
                                  const SizedBox(width: 10),
                                  Text(img),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedImage = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _submitStock,
                          child: const Text("Tambah"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Daftar Stok", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (state is StockLoading)
                  const CircularProgressIndicator()
                else if (state is StockLoadSuccess)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.stockList.length,
                    itemBuilder: (context, index) {
                      final stock = state.stockList[index];
                      final imageName = stock.image ?? 'placeholder.png';
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/images/$imageName',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                          title: Text("Quantity: ${stock.quantity}"),
                          subtitle: Text("Price: Rp ${stock.price}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _showEditDialog(stock),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(stock.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else if (state is StockFailure)
                  Center(child: Text("❌ ${state.message}"))
                else
                  const Text("Data stok belum tersedia."),
              ],
            ),
          );
        },
      ),
    );
  }
}
