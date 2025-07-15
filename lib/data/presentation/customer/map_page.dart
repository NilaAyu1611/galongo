import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Marker? _pickedMarker;
  String? _pickedAddress;
  CameraPosition? _initialCamera;

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
  }

  Future<void> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layanan lokasi tidak aktif.')),
      );
      return;
    }

    // Cek & minta permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission lokasi ditolak.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission lokasi ditolak permanen.')),
      );
      return;
    }

    // Permission granted, ambil lokasi
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      _initialCamera = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );
      setState(() {});
    } catch (e) {
      _initialCamera = const CameraPosition(target: LatLng(0, 0), zoom: 2);
      setState(() {});
    }
  }

  void _onTapMap(LatLng latlng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latlng.latitude,
        latlng.longitude,
      );
      final place = placemarks.first;

      setState(() {
        _pickedMarker = Marker(
          markerId: const MarkerId("picked"),
          position: latlng,
          infoWindow: InfoWindow(
            title: place.name ?? "Lokasi",
            snippet: "${place.locality}, ${place.country}",
          ),
        );
        _pickedAddress =
            "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil alamat.')),
      );
    }
  }

  void _confirmLocation() {
    if (_pickedMarker != null && _pickedAddress != null) {
      Navigator.pop(context, {
        'address': _pickedAddress,
        'latlng': _pickedMarker!.position,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCamera == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera!,
            onMapCreated: (controller) => _controller.complete(controller),
            onTap: _onTapMap,
            markers: _pickedMarker != null ? {_pickedMarker!} : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          if (_pickedAddress != null)
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_pickedAddress!),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _pickedAddress != null
          ? FloatingActionButton.extended(
              onPressed: _confirmLocation,
              label: const Text("Pilih Lokasi"),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
