import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderData {
  final String? contactNumber;                
  final Map<String, dynamic>? customers;      
  final GeoPoint location;                    
  final String email;
  final String shopName;
  final String ownerName;
  final List<Map<String, dynamic>> rateList;       
  final String description;
  final bool isVerified;
  String status;                              

  ProviderData({
    this.contactNumber,
    this.customers,
    required this.location,
    required this.email,
    required this.ownerName,
    required this.shopName,
    required this.rateList,
    required this.description,
    required this.isVerified,
    required this.status,
  });

  factory ProviderData.fromMap(Map<String, dynamic> data) {
    return ProviderData(
      contactNumber: data['contactNumber'],                   
      customers: data['customers'],                           
      location: data['location'] is GeoPoint
      ? data['location']
      : const GeoPoint(0, 0),
    
      email: data['mail'] ?? '',                              
      ownerName: data['name'] ?? '',                          
      shopName: data['shopName'] ?? '',                                                   
      description: data['description'] ?? '',
      isVerified: data['isVerified'] ?? false,
      status: data['status'] ?? 'Closed',
        rateList: (() {
        final value = data['rateList'];
        if (value is List) {
          return value.map((e) => Map<String, dynamic>.from(e)).toList();
        } else if (value is Map) {
          return [Map<String, dynamic>.from(value)];
        } else {
          return <Map<String, dynamic>>[];
        }
      })(),                     
    );
  }
}



