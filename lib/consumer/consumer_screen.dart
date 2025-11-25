import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'profile.dart';
import 'settings.dart';

class ConsumerScreen extends StatefulWidget {
  const ConsumerScreen({super.key});

  @override
  State<ConsumerScreen> createState() => _ConsumerScreen();
}

class _ConsumerScreen extends State<ConsumerScreen> {
  final MapController _mapController = MapController();

  LatLng _currentLocation = LatLng(31.514, 74.354);
  String _currentAddress = "Lahore";

  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestLocation();
      _loadLocationFromDatabase();
    });
  }

  Future<void> _getPlaceName(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String area = place.subLocality ?? place.thoroughfare ?? "";
        String city = place.locality ?? "";

        String formattedAddress = "$area, $city";
        if (area.isEmpty) formattedAddress = city;

        if (mounted) {
          setState(() {
            _currentAddress = formattedAddress;
          });
        }
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  Future<void> _loadLocationFromDatabase() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('userConsumer')
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;

          if (data.containsKey('location')) {
            var locMap = data['location'];
            double lat = locMap['latitude'] ?? 0.0;
            double lng = locMap['longitude'] ?? 0.0;

            if (lat != 0.0 && lng != 0.0) {
              setState(() {
                _currentLocation = LatLng(lat, lng);
              });
              _mapController.move(LatLng(lat, lng), 16);
              _getPlaceName(lat, lng);
            }
          }
        }
      } catch (e) {
        debugPrint("Error fetching DB location: $e");
      }
    }
  }

  Future<void> _checkAndRequestLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Location services are disabled.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Turn On',
              textColor: Colors.white,
              onPressed: () {
                Geolocator.openLocationSettings();
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showPermissionBottomSheet();
    } else {
      _getUserLocation();
    }
  }

  void _showPermissionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 50, color: Colors.red),
              const SizedBox(height: 15),
              const Text(
                "Enable Location?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Hazir needs your location to find shops near you and secure your place in the queue.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(2, 62, 138, 1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _getUserLocation();
                  },
                  child: const Text("Allow Access",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLocating = true);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLocating = false);
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newPos = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = newPos;
      });

      _mapController.move(newPos, 16);

      _getPlaceName(position.latitude, position.longitude);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('userConsumer')
            .doc(user.uid)
            .update({
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude
          }
        });
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    } finally {
      setState(() => _isLocating = false);
    }
  }

  Widget _buildDraggableSheet() {
    final List<String> categories = [
      "Karyana Store",
      "Barber",
      "Car Mechanic",
      "Bike Mechanic",
      "Carpenter",
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.10,
      minChildSize: 0.10,
      maxChildSize: 0.55,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            controller: scrollController,
            children: [
              const SizedBox(height: 10),
              
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                "Select a Category",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ...categories.map((category) {
                return ListTile(
                  leading: const Icon(Icons.store_mall_directory),
                  title: Text(category),
                  onTap: () {
                    print("Selected $category");
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      _currentAddress,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'HAZIR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 80,
              color: const Color.fromRGBO(2, 62, 138, 1),
              alignment: Alignment.center,
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                final User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(userId: currentUser.uid),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No user logged in!")),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://api.maptiler.com/maps/basic-v2/{z}/{x}/{y}.png?key=S3Rrhs7ZQnmWbyTvy7Es',
                userAgentPackageName: 'com.example.hazir',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 60,
                    height: 60,
                    child: const Icon(Icons.location_pin,
                        color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _getUserLocation,
              child: _isLocating
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.my_location, color: Colors.black87),
            ),
          ),

          _buildDraggableSheet(),
        ],
      ),
    );
  }
}