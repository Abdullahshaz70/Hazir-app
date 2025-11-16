import 'package:flutter/material.dart';

class Queue extends StatefulWidget {
  const Queue({super.key});

  @override
  State<Queue> createState() => _QueueState();
}

class _QueueState extends State<Queue> {

  List<Map<String, dynamic>> liveQueue = [
    {
      'name': 'Ali Khan',
      'service': 'Haircut',
      'ticket': '#A01',
      'eta': '12m',
    },
    {
      'name': 'Bilal Ahmed',
      'service': 'Beard Trim',
      'ticket': '#A02',
      'eta': '20m',
    },
  ];

  String nowServing = 'No one yet';

  void _startService(String name) {
    setState(() {
      nowServing = name;
    });
  }

  void _skipCustomer(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${liveQueue[index]['name']} skipped")),
    );
  }

  void _removeCustomer(int index) {
    setState(() {
      liveQueue.removeAt(index);
    });
  }

  void _callNext() {
    if (liveQueue.isNotEmpty) {
      setState(() {
        nowServing = liveQueue.first['name'];
        liveQueue.removeAt(0);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No one left in the queue!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Live Queue",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 4),
            const Text(
              "Avg/Service: 8–10m",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Live Queue Cards
            if (liveQueue.isEmpty)
              const Text(
                "No one in queue.",
                style: TextStyle(color: Colors.black54),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: liveQueue.length,
                itemBuilder: (context, index) {
                  final customer = liveQueue[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "• ${customer['service']}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Ticket ${customer['ticket']} • ETA ${customer['eta']}",
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _queueActionButton(
                                  "Start", Colors.green[100]!, Colors.green[800]!,
                                  () {
                                _startService(customer['name']);
                              }),
                              const SizedBox(width: 8),
                              _queueActionButton(
                                  "Skip", Colors.amber[100]!, Colors.orange[800]!,
                                  () {
                                _skipCustomer(index);
                              }),
                              const SizedBox(width: 8),
                              _queueActionButton(
                                  "Remove", Colors.red[100]!, Colors.red[800]!,
                                  () {
                                _removeCustomer(index);
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 12),

            Text(
              "Total in queue: ${liveQueue.length}",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            const SizedBox(height: 4),
            const Text(
              "Est. wait for new ticket: 27m",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Now Serving Section
            const Text(
              "Now Serving",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                nowServing,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),

            // Bottom buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomButton("Call Next", Colors.green[700]!),
                _bottomButton("No-show", Colors.amber[700]!),
                _bottomButton("Done", Colors.blue[700]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _queueActionButton(
      String label, Color bgColor, Color textColor, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style:
                  TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomButton(String text, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () {
            if (text == "Call Next") _callNext();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
