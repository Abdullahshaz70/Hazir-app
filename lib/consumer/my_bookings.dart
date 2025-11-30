// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class MyBookingsScreen extends StatelessWidget {
//   const MyBookingsScreen({super.key});

//   final Color hazirBlue = const Color.fromRGBO(2, 62, 138, 1);

//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text("My Bookings"),
//         backgroundColor: Colors.white,
//         foregroundColor: hazirBlue,
//         elevation: 0,
//       ),
//       body: user == null
//           ? const Center(child: Text("Please log in to see bookings."))
//           : StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('userConsumer')
//             .doc(user.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(child: Text("Error loading bookings"));
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final data = snapshot.data!.data() as Map<String, dynamic>?;
//           final currentQueueRaw = data?['currentQueue'];

//           List<Map<String, dynamic>> activeBookings = [];

//           if (currentQueueRaw != null && currentQueueRaw is List) {
//             for (var item in currentQueueRaw) {
//               if (item is Map<String, dynamic> &&
//                   item['status'] != 'Completed') {
//                 activeBookings.add(item);
//               }
//             }
//           }

//           if (activeBookings.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.event_busy,
//                       size: 60, color: Colors.grey[400]),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No active bookings",
//                     style:
//                     TextStyle(color: Colors.grey[600], fontSize: 16),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: activeBookings.length,
//             itemBuilder: (context, index) {
//               final booking = activeBookings[index];

//               final String shopName =
//                   booking['shopName'] ?? "Unknown Shop";
//               final String service = booking['service'] ?? "Service";
//               final int position = booking['queuePosition'] ?? 0;
//               final String status = booking['status'] ?? "Waiting";
//               final int price = booking['price'] ?? 0;

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (index == 0)
//                     const Padding(
//                       padding: EdgeInsets.only(bottom: 12),
//                       child: Text(
//                         "Active Tickets",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16)),
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                             color: hazirBlue.withOpacity(0.1)),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       shopName,
//                                       style: const TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       service,
//                                       style: TextStyle(
//                                           color: Colors.grey[600],
//                                           fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 6),
//                                 decoration: BoxDecoration(
//                                   color: status == "Waiting"
//                                       ? Colors.orange.withOpacity(0.1)
//                                       : Colors.green.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   status,
//                                   style: TextStyle(
//                                     color: status == "Waiting"
//                                         ? Colors.orange
//                                         : Colors.green,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           const Divider(height: 30),
//                           Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               _buildInfoColumn("Ticket", "#$position"),
//                               _buildInfoColumn("Price", "Rs. $price"),
//                               _buildInfoColumn(
//                                   "Est. Wait", "${position * 15}m"),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoColumn(String label, String value) {
//     return Column(
//       children: [
//         Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
//         const SizedBox(height: 4),
//         Text(value,
//             style: TextStyle(
//                 color: hazirBlue, fontWeight: FontWeight.bold, fontSize: 16)),
//       ],
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  final Color hazirBlue = const Color.fromRGBO(2, 62, 138, 1);

  Future<void> _cancelBooking(BuildContext context, Map<String, dynamic> booking, String userId) async {
    try {
      final String? shopId = booking['shopId'];
      final String? bookingId = booking['bookingId'];

      if (shopId == null || bookingId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid booking data")),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final batch = FirebaseFirestore.instance.batch();

      // 1. Remove from user's currentQueue
      final userRef = FirebaseFirestore.instance.collection('userConsumer').doc(userId);
      batch.update(userRef, {
        'currentQueue': FieldValue.arrayRemove([booking])
      });

      // 2. Remove from provider's queue
      final shopRef = FirebaseFirestore.instance.collection('userProvider').doc(shopId);
      final shopDoc = await shopRef.get();
      
      if (shopDoc.exists) {
        final shopData = shopDoc.data() as Map<String, dynamic>?;
        final queue = shopData?['queue'] as List?;
        
        if (queue != null) {
          // Find and remove the booking from provider's queue
          final updatedQueue = queue.where((item) {
            if (item is Map<String, dynamic>) {
              return item['bookingId'] != bookingId;
            }
            return true;
          }).toList();
          
          // Recalculate queue positions
          for (int i = 0; i < updatedQueue.length; i++) {
            if (updatedQueue[i] is Map<String, dynamic>) {
              updatedQueue[i]['queuePosition'] = i + 1;
            }
          }
          
          batch.update(shopRef, {'queue': updatedQueue});
        }
      }

      await batch.commit();

      // Close loading dialog
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking cancelled successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog if open
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cancelling booking: $e")),
      );
    }
  }

  Future<bool?> _showCancelDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Booking"),
        content: const Text("Are you sure you want to cancel this booking?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.white,
        foregroundColor: hazirBlue,
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: Text("Please log in to see bookings."))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userConsumer')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading bookings"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final currentQueueRaw = data?['currentQueue'];

          List<Map<String, dynamic>> activeBookings = [];

          if (currentQueueRaw != null && currentQueueRaw is List) {
            for (var item in currentQueueRaw) {
              if (item is Map<String, dynamic> &&
                  item['status'] != 'Completed') {
                activeBookings.add(item);
              }
            }
          }

          if (activeBookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy,
                      size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No active bookings",
                    style:
                    TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: activeBookings.length,
            itemBuilder: (context, index) {
              final booking = activeBookings[index];

              final String shopName =
                  booking['shopName'] ?? "Unknown Shop";
              final String service = booking['service'] ?? "Service";
              final int position = booking['queuePosition'] ?? 0;
              final String status = booking['status'] ?? "Waiting";
              final int price = booking['price'] ?? 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        "Active Tickets",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Dismissible(
                    key: Key(booking['bookingId'] ?? 'booking_$index'),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await _showCancelDialog(context);
                    },
                    onDismissed: (direction) {
                      _cancelBooking(context, booking, user.uid);
                    },
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white, size: 32),
                          SizedBox(height: 4),
                          Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: hazirBlue.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shopName,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        service,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: status == "Waiting"
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: status == "Waiting"
                                          ? Colors.orange
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(height: 30),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoColumn("Ticket", "#$position"),
                                _buildInfoColumn("Price", "Rs. $price"),
                                _buildInfoColumn(
                                    "Est. Wait", "${position * 15}m"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: hazirBlue, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}