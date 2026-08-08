import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/location_service.dart';
import '../../../core/config/app_config.dart';
import '../../../widgets/map_fallback.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _pickedLocation = const LatLng(37.7749, -122.4194); // Default to SF
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    final pos = await LocationService.getCurrentLocation();
    if (pos != null) {
      setState(() {
        _pickedLocation = LatLng(pos.latitude, pos.longitude);
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_pickedLocation));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.primary),
            onPressed: () => Navigator.pop(context, _pickedLocation),
          ),
        ],
      ),
      body: !AppConfig.isGoogleMapsConfigured
          ? const MapFallback()
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _pickedLocation, zoom: 15),
                  onMapCreated: (controller) => _mapController = controller,
                  onCameraMove: (pos) => _pickedLocation = pos.target,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                const Center(
                  child: Icon(Icons.location_on, size: 40, color: AppColors.primary),
                ),
              ],
            ),
    );
  }
}
