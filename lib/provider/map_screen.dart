// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class MapPick extends StatefulWidget {
//   // const MapPick({super.key});
//   final LatLng? initialLocation;
//   const MapPick({super.key, this.initialLocation});
//   @override
//   State<MapPick> createState() => _MapPickState();
// }

// class _MapPickState extends State<MapPick> {
//   final LatLng lahore = LatLng(31.5204, 74.3587);
//   late LatLng pickedLocation;
//   late final MapController mapController;

//   @override
//   void initState() {
//     super.initState();
//     pickedLocation = lahore;
//     mapController = MapController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Pick Location")),
//       body: FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//           initialCenter: lahore,
//           initialZoom: 13,
//           onTap: (tapPosition, point) {
//             setState(() => pickedLocation = point);
//           },
//         ),
//         children: [
//           // TileLayer(
//           //   urlTemplate:
//           //       'https://tile.openstreetmap.org/{z}/{x}/{y}.png', 
//           //   userAgentPackageName: 'com.example.hazir',
//           // ),
//           TileLayer(
//   urlTemplate:
//       'https://api.maptiler.com/maps/basic-v2/{z}/{x}/{y}.png?key=S3Rrhs7ZQnmWbyTvy7Es',
//   userAgentPackageName: 'com.example.hazir',
// ),

//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: pickedLocation,
//                 width: 60,
//                 height: 60,
//                 child: const Icon(Icons.location_pin,
//                     color: Colors.red, size: 40),
//               ),
//             ],
//           ),
//         ],
//       ),
        
//         floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: Colors.green,
//         onPressed: () => Navigator.pop(context, pickedLocation),
//         label: const Text("Confirm Location"),
//         icon: const Icon(Icons.check),
//       ),
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class MapPick extends StatefulWidget {
  final LatLng? initialLocation;
  const MapPick({super.key, this.initialLocation});

  @override
  State<MapPick> createState() => _MapPickState();
}

class _MapPickState extends State<MapPick> {
  final LatLng lahore = LatLng(31.5204, 74.3587);
  late LatLng pickedLocation;
  late final MapController mapController;
  String locationName = "";
  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    pickedLocation = widget.initialLocation ?? lahore;
    mapController = MapController();
    
    if (widget.initialLocation != null) {
      _updateLocationName(widget.initialLocation!);
    }
  }

  Future<void> _updateLocationName(LatLng latLng) async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        List<String> parts = [];
        
        if (p.street != null && p.street!.isNotEmpty) parts.add(p.street!);
        if (p.subLocality != null && p.subLocality!.isNotEmpty) parts.add(p.subLocality!);
        if (p.locality != null && p.locality!.isNotEmpty) parts.add(p.locality!);
        if (p.country != null && p.country!.isNotEmpty) parts.add(p.country!);
        
        if (parts.isNotEmpty) {
          setState(() {
            locationName = parts.join(', ');
          });
        } else {
          setState(() {
            locationName = "${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}";
          });
        }
      }
    } catch (e) {
      print("Error getting location name: $e");
      setState(() {
        locationName = "${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}";
      });
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: Stack(
        children: [


        FlutterMap(
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
          
          
          
          // if (locationName.isNotEmpty)
          //   Positioned(
              // top: 16,
              // left: 16,
              // right: 16,
              // child: Material(
              //   elevation: 4,
              //   borderRadius: BorderRadius.circular(8),
              //   child: Container(
              //     padding: const EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: isLoadingLocation
              //         ? const Row(
              //             children: [
              //               SizedBox(
              //                 width: 16,
              //                 height: 16,
              //                 child: CircularProgressIndicator(strokeWidth: 2),
              //               ),
              //               SizedBox(width: 12),
              //               Text("Getting location..."),
              //             ],
              //           )
              //         : Text(
              //             locationName,
              //             style: const TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //   ),
            //   ),
            // ),
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