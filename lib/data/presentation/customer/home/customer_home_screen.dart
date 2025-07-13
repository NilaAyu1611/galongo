import 'package:flutter/material.dart';
import 'package:galongo/core/constants/colors.dart';
import 'package:galongo/core/components/spaces.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Pelanggan'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Tambahkan fungsi logout di sini
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout belum diimplementasikan')),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, Selamat datang di Galongo!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceHeight(20),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blueLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Di sini kamu bisa melihat profil, mengatur akun, memesan layanan, dan lainnya.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SpaceHeight(30),
            const Text(
              'Fitur Utama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SpaceHeight(10),
            _HomeFeatureTile(
              icon: Icons.person,
              title: 'Profil Saya',
              onTap: () {
                // TODO: Navigasi ke halaman profil customer
              },
            ),
            _HomeFeatureTile(
              icon: Icons.shopping_cart,
              title: 'Pesanan Saya',
              onTap: () {
                // TODO: Navigasi ke daftar pesanan
              },
            ),
            _HomeFeatureTile(
              icon: Icons.settings,
              title: 'Pengaturan Akun',
              onTap: () {
                // TODO: Navigasi ke pengaturan
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeFeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HomeFeatureTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
