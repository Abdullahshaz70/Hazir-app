// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ShopProfileScreen extends StatefulWidget {
//   final String providerId;

//   const ShopProfileScreen({super.key, required this.providerId});

//   @override
//   State<ShopProfileScreen> createState() => _ShopProfileScreenState();
// }

// class _ShopProfileScreenState extends State<ShopProfileScreen> {
//   String? _selectedService;
//   int? _selectedPrice;
//   bool _isJoining = false;

//   final Color hazirBlue = const Color.fromRGBO(2, 62, 138, 1);
//   final Color hazirYellow = const Color(0xFFFFF9C4);

//   Future<void> _handleJoinButton(Map<String, dynamic> providerData) async {
//     if (_selectedService == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a service first!")),
//       );
//       return;
//     }

//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     setState(() => _isJoining = true);

//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('userConsumer')
//           .doc(user.uid)
//           .get();

//       if (userDoc.exists && userDoc.data() != null) {
//         var userData = userDoc.data() as Map<String, dynamic>;

//         if (userData.containsKey('currentQueue') &&
//             userData['currentQueue'] != null) {
//           List<dynamic> currentQueueList = userData['currentQueue'] as List<dynamic>;

//           bool alreadyInQueue = currentQueueList.any((booking) {
//             return booking['providerId'] == widget.providerId &&
//                 booking['status'] != 'Completed';
//           });

//           if (alreadyInQueue) {
//             if (mounted) {
//               bool? shouldAdd = await showDialog<bool>(
//                 context: context,
//                 builder: (ctx) => AlertDialog(
//                   title: const Text("Already in Queue"),
//                   content: Text(
//                       "You are already in the queue for ${providerData['name'] ?? 'this shop'}. Do you want to add another service?"),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(ctx, false),
//                       child: const Text("Cancel"),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.pop(ctx, true),
//                       child: const Text("Yes, Add Again"),
//                     ),
//                   ],
//                 ),
//               );

//               if (shouldAdd != true) {
//                 setState(() => _isJoining = false);
//                 return;
//               }
//             }
//           }
//         }
//       }

//       await _performJoinTransaction(user, providerData);
//     } catch (e) {
//       debugPrint("Error in pre-check: $e");
//       setState(() => _isJoining = false);
//     }
//   }

//   Future<void> _performJoinTransaction(
//       User user, Map<String, dynamic> providerData) async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('userConsumer')
//           .doc(user.uid)
//           .get();

//       String userName = "Unknown";
//       if (userDoc.exists && userDoc.data() != null) {
//         userName =
//             (userDoc.data() as Map<String, dynamic>)['name'] ?? "Unknown";
//       }

//       List<dynamic> customersList = providerData['customers'] ?? [];
//       int newPosition = customersList.length + 1;

//       String bookingId = DateTime.now().millisecondsSinceEpoch.toString();

//       Map<String, dynamic> newCustomerForProvider = {
//         "bookingId": bookingId,
//         "name": userName,
//         "notes": "Online Booking",
//         "prepaid": "No",
//         "queuePosition": newPosition,
//         "service": _selectedService,
//         "price": _selectedPrice,
//         "uid": user.uid,
//         "timestamp": DateTime.now().toIso8601String(),
//       };

//       Map<String, dynamic> newQueueForConsumer = {
//         "bookingId": bookingId,
//         "providerId": widget.providerId,
//         "shopName": providerData['name'] ?? "Shop",
//         "queuePosition": newPosition,
//         "service": _selectedService,
//         "price": _selectedPrice,
//         "status": "Waiting",
//         "joinedAt": Timestamp.now(),
//       };

//       WriteBatch batch = FirebaseFirestore.instance.batch();

//       DocumentReference providerRef = FirebaseFirestore.instance
//           .collection('userProvider')
//           .doc(widget.providerId);

//       batch.update(providerRef, {
//         "customers": FieldValue.arrayUnion([newCustomerForProvider])
//       });

//       DocumentReference consumerRef =
//       FirebaseFirestore.instance.collection('userConsumer').doc(user.uid);

//       batch.update(consumerRef, {
//         "currentQueue": FieldValue.arrayUnion([newQueueForConsumer])
//       });

//       await batch.commit();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Joined Queue! Your Ticket is #$newPosition")),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error joining: $e")),
//       );
//     } finally {
//       if (mounted) setState(() => _isJoining = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text("Shop Details"),
//         backgroundColor: Color.fromRGBO(2, 62, 138, 1),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('userProvider')
//             .doc(widget.providerId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError)
//             return const Center(child: Text("Error loading shop"));
//           if (!snapshot.hasData)
//             return const Center(child: CircularProgressIndicator());

//           var data = snapshot.data!.data() as Map<String, dynamic>;

//           List<dynamic> rateListRaw = data['rateList'] ?? [];
//           List<dynamic> customersRaw = data['customers'] ?? [];

//           String shopName = data['name'] ?? "Unknown Shop";
//           String desc = data['description'] ?? "";
//           double rating = 4.8;

//           int queueLength = customersRaw.length;
//           int waitTime = queueLength * 15;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: hazirBlue,
//                         child: Text(
//                           shopName.isNotEmpty ? shopName[0].toUpperCase() : "?",
//                           style: const TextStyle(
//                               fontSize: 24,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(shopName,
//                                 style: const TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 4),
//                             Text(desc,
//                                 style: TextStyle(
//                                     color: Colors.grey[600], fontSize: 12)),
//                             const SizedBox(height: 6),
//                             Row(
//                               children: [
//                                 const Icon(Icons.star,
//                                     color: Colors.amber, size: 16),
//                                 const SizedBox(width: 4),
//                                 Text("$rating (200+ ratings)",
//                                     style: const TextStyle(
//                                         fontSize: 12, color: Colors.grey)),
//                               ],
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text("Select Service",
//                     style:
//                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 if (rateListRaw.isEmpty)
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text("No services available"),
//                   ),
//                 ...rateListRaw.map((item) {
//                   String name = item['service'];
//                   int price = item['price'];
//                   bool isSelected = _selectedService == name;

//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedService = name;
//                         _selectedPrice = price;
//                       });
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 8),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? hazirBlue.withOpacity(0.1)
//                             : Colors.white,
//                         border: Border.all(
//                             color: isSelected ? hazirBlue : Colors.transparent),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(name, style: const TextStyle(fontSize: 15)),
//                           Text("Rs. $price",
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 15)),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildStatCard("Queue Length", "$queueLength",
//                             Colors.blue.shade50, Colors.blue)),
//                     const SizedBox(width: 10),
//                     Expanded(
//                         child: _buildStatCard(
//                             "Est. Wait",
//                             _formatDuration(waitTime),
//                             Colors.orange.shade50,
//                             Colors.orange)),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: hazirYellow,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Lunch Break",
//                           style: TextStyle(
//                               color: Colors.brown[700],
//                               fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 4),
//                       Text("1:00 PM - 2:00 PM",
//                           style: TextStyle(color: Colors.brown[700])),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: hazirBlue,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                     onPressed:
//                     _isJoining ? null : () => _handleJoinButton(data),
//                     child: _isJoining
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Join Queue Now",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String value, Color bg, Color text) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           Text(title,
//               style: TextStyle(color: text, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 5),
//           Text(value,
//               style: TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold, color: text)),
//         ],
//       ),
//     );
//   }

//   String _formatDuration(int minutes) {
//     if (minutes < 60) return "$minutes min";
//     int h = minutes ~/ 60;
//     int m = minutes % 60;
//     if (m == 0) return "$h hr";
//     return "$h hr $m min";
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopProfileScreen extends StatefulWidget {
  final String providerId;

  const ShopProfileScreen({super.key, required this.providerId});

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  String? _selectedService;
  int? _selectedPrice;
  bool _isJoining = false;

  final Color hazirBlue = const Color.fromRGBO(2, 62, 138, 1);
  final Color hazirYellow = const Color(0xFFFFF9C4);

  Future<void> _handleJoinButton(Map<String, dynamic> providerData) async {
    if (providerData['status'] == "Closed") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Shop is closed right now")));
      return;
    }

    if (_selectedService == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please select a service first!")));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isJoining = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('userConsumer')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('currentQueue')) {
          final currentQueue = List.from(data['currentQueue'] ?? []);
          bool already = currentQueue.any((q) =>
              q['providerId'] == widget.providerId && q['status'] != 'Completed');

          if (already) {
            bool? allow = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Already in Queue"),
                content: Text(
                    "You are already in the queue for ${providerData['name']}. Add another service?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text("Yes, Add Again")),
                ],
              ),
            );

            if (allow != true) {
              setState(() => _isJoining = false);
              return;
            }
          }
        }
      }

      await _performJoinTransaction(user, providerData);
    } catch (e) {
      setState(() => _isJoining = false);
    }
  }

  Future<void> _performJoinTransaction(
      User user, Map<String, dynamic> providerData) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('userConsumer')
          .doc(user.uid)
          .get();

      String userName =
          userDoc.exists ? (userDoc.data() as Map<String, dynamic>)['name'] : "Unknown";

      List customersList = providerData['customers'] ?? [];
      int pos = customersList.length + 1;

      String bookingId = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> prov = {
        "bookingId": bookingId,
        "name": userName,
        "notes": "Online Booking",
        "prepaid": "No",
        "queuePosition": pos,
        "service": _selectedService,
        "price": _selectedPrice,
        "uid": user.uid,
        "timestamp": DateTime.now().toIso8601String(),
      };

      Map<String, dynamic> con = {
        "bookingId": bookingId,
        "providerId": widget.providerId,
        "shopName": providerData['name'] ?? "Shop",
        "queuePosition": pos,
        "service": _selectedService,
        "price": _selectedPrice,
        "status": "Waiting",
        "joinedAt": Timestamp.now(),
      };

      final batch = FirebaseFirestore.instance.batch();

      final providerRef = FirebaseFirestore.instance
          .collection('userProvider')
          .doc(widget.providerId);

      final consumerRef =
          FirebaseFirestore.instance.collection('userConsumer').doc(user.uid);

      batch.update(providerRef, {"customers": FieldValue.arrayUnion([prov])});
      batch.update(consumerRef, {"currentQueue": FieldValue.arrayUnion([con])});

      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Joined Queue! Your Ticket is #$pos")));
        Navigator.pop(context);
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Shop Details"),
        backgroundColor: hazirBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userProvider')
            .doc(widget.providerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final shopName = data['name'] ?? "Unknown Shop";
          final desc = data['description'] ?? "";
          final status = data['status'] ?? "Open";
          final rateListRaw = data['rateList'] ?? [];
          final customersRaw = data['customers'] ?? [];

          final queueLength = customersRaw.length;
          final waitTime = queueLength * 15;

          final bool isClosed = status == "Closed";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: hazirBlue,
                        child: Text(
                          shopName.isNotEmpty ? shopName[0] : "?",
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(shopName,
                                      style: const TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isClosed
                                        ? Colors.red.withOpacity(0.2)
                                        : Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isClosed ? "CLOSED" : "OPEN",
                                    style: TextStyle(
                                      color: isClosed ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(desc,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text("Select Service",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                if (rateListRaw.isEmpty)
                  const Text("No services available")
                else
                  ...rateListRaw.map((item) {
                    String name = item['service'];
                    int price = item['price'];
                    bool isSelected = _selectedService == name;

                    return GestureDetector(
                      onTap: isClosed
                          ? null
                          : () {
                              setState(() {
                                _selectedService = name;
                                _selectedPrice = price;
                              });
                            },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? hazirBlue.withOpacity(0.1)
                              : Colors.white,
                          border: Border.all(
                              color: isSelected ? hazirBlue : Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name, style: const TextStyle(fontSize: 15)),
                            Text("Rs. $price",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                        child: _buildStatCard(
                            "Queue Length", "$queueLength", Colors.blue.shade50, Colors.blue)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildStatCard("Est. Wait",
                            _formatDuration(waitTime), Colors.orange.shade50, Colors.orange)),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isClosed ? Colors.grey : hazirBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed:
                        isClosed ? null : (_isJoining ? null : () => _handleJoinButton(data)),
                    child: _isJoining
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isClosed ? "Shop Closed" : "Join Queue Now",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: text, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: text)),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return "$minutes min";
    int h = minutes ~/ 60;
    int m = minutes % 60;
    if (m == 0) return "$h hr";
    return "$h hr $m min";
  }
}








