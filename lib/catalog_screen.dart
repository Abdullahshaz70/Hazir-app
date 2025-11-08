import 'package:flutter/material.dart';
import 'package:messenger/models/provider_model.dart';

import 'add_Service.dart';

class Catalog extends StatefulWidget {
  final ProviderData providerData;
  const Catalog({super.key, required this.providerData});

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  late TextEditingController _shopNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _ownerNameController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _shopNameController =
        TextEditingController(text: widget.providerData.shopName);
    _descriptionController =
        TextEditingController(text: widget.providerData.description);
    _ownerNameController =
        TextEditingController(text: widget.providerData.ownerName);
    _contactController =
        TextEditingController(text: widget.providerData.contactNumber);
    _emailController = TextEditingController(text: widget.providerData.email);
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
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
              "Shop Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _shopNameController,
              decoration: InputDecoration(
                labelText: "Shop Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ownerNameController,
              decoration: InputDecoration(
                labelText: "Owner Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

TextField(
  controller: _contactController,
  keyboardType: TextInputType.phone,
  readOnly: true, 
  enabled: false,  
  decoration: InputDecoration(
    labelText: "Contact Number",
    hintText: "+92 300 1234567",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.grey[200], 
  ),
),
const SizedBox(height: 16),
TextField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  readOnly: true,
  enabled: false,
  decoration: InputDecoration(
    labelText: "Email Address",
    hintText: "****@example.com",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.grey[200],
  ),
),

SizedBox(height: 16,),
SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    onPressed: () {
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: const Text(
      "Save Profile",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),





            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rate List",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddService(providerData: widget.providerData,)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  child: const Text(
                    "Add Service",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.providerData.rateList.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text(
                  "No services added yet.",
                  style: TextStyle(color: Colors.black54),
                ),
              )
            else
              Column(
                children: widget.providerData.rateList.map((service) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(service['service'] ?? 'Unnamed'),
                      subtitle: Text('Price: Rs ${service['price'] ?? 'N/A'}'),
                    ),
                  );
                }).toList(),
              )
          ],
        ),
      ),
    );
  }
}
