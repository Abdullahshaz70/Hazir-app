import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/material.dart';

class ConsumerScreen extends StatefulWidget {
  

  @override
  State<ConsumerScreen> createState() => _ConsumerScreen();
}

class _ConsumerScreen extends State<ConsumerScreen> {

  final LatLng _center = LatLng(31.514,74.354);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(
        children: [

          FlutterMap(
            options: MapOptions(
              initialCenter:_center, 
              initialZoom: 16,
            ),
            children: [
            // TileLayer(
            //     urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=S3Rrhs7ZQnmWbyTvy7Es',
            //     userAgentPackageName: 'com.example.hazir',
            //   ),

              TileLayer(
                urlTemplate: 'https://api.maptiler.com/maps/basic-v2/{z}/{x}/{y}.png?key=S3Rrhs7ZQnmWbyTvy7Es',
                userAgentPackageName: 'com.example.hazir',
              ),



              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    width: 60,
                    height: 60,
                    child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),


          Positioned(
            top: 50,
            left: 30,
            child: Material(
              elevation: 3,
              shape: const CircleBorder(),
              
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: (){},
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.menu),
                ),
              ),
            )
          ),

        ],
      ),
    );
  }
}
