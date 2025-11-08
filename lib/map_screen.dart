import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPick extends StatefulWidget {
  const MapPick({super.key});

  @override
  State<MapPick> createState() => _MapPickState();
}

class _MapPickState extends State<MapPick> {
  final LatLng lahore = LatLng(31.5204, 74.3587);
  late LatLng pickedLocation;
  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    pickedLocation = lahore;
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: lahore,
          initialZoom: 13,
          onTap: (tapPosition, point) {
            setState(() => pickedLocation = point);
          },
        ),
        children: [
          // TileLayer(
          //   urlTemplate:
          //       'https://tile.openstreetmap.org/{z}/{x}/{y}.png', 
          //   userAgentPackageName: 'com.example.hazir',
          // ),
          TileLayer(
  urlTemplate:
      'https://api.maptiler.com/maps/basic-v2/{z}/{x}/{y}.png?key=S3Rrhs7ZQnmWbyTvy7Es',
  userAgentPackageName: 'com.example.hazir',
),

          MarkerLayer(
            markers: [
              Marker(
                point: pickedLocation,
                width: 60,
                height: 60,
                child: const Icon(Icons.location_pin,
                    color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.pop(context, pickedLocation),
        label: const Text("Confirm Location"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
