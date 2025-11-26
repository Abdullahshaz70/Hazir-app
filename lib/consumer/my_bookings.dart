import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  final Color hazirBlue = const Color.fromRGBO(2, 62, 138, 1);

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
                  Card(
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