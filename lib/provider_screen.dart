import 'package:flutter/material.dart';
import 'queue_screen.dart';
import 'walkin_screen.dart';
import 'catalog_screen.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "HAZIR — Provider",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 2),
              ],
            ),
          ),
          actions: [
          
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isOpen ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isOpen ? "Open" : "Closed",
                style: TextStyle(
                  color: isOpen ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              child: const Text(
                "Toggle",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black54,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                tabs: [
                  Tab(text: "Queue"),
                  Tab(text: "Walk-in"),
                  Tab(text: "Catalog"),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Queue(),
            Walkin(),
            Catalog(),
          ],
        ),
      ),
    );
  }
}
