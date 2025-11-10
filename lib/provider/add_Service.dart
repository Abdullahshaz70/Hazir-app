import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger/models/provider_model.dart';


class AddService extends StatefulWidget {
  final ProviderData providerData;
  const AddService({super.key , required this.providerData});
  
  @override
  State<AddService> createState() => _AddService();
}

class _AddService extends State<AddService> {
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  

  void _addRate() async {
    final service = serviceController.text.trim();
    final price = priceController.text.trim();

    if (service.isNotEmpty && price.isNotEmpty) {


      setState(() {
        


        serviceController.clear();
        priceController.clear();
      });
    }
  }

  // void _editRate(int index) {
  //   final item = rateList[index];
  //   final TextEditingController editService = TextEditingController(text: item['service']);
  //   final TextEditingController editPrice = TextEditingController(text: item['price']);

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Edit Service"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: editService,
  //               decoration: const InputDecoration(labelText: "Service Name"),
  //             ),
  //             const SizedBox(height: 10),
  //             TextField(
  //               controller: editPrice,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(labelText: "Price"),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 rateList[index]['service'] = editService.text.trim();
  //                 rateList[index]['price'] = editPrice.text.trim();
  //               });
  //               Navigator.pop(context);
  //             },
  //             child: const Text("Update"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _deleteRate(int index) {
  //   setState(() {
  //     rateList.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Service"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: serviceController,
              decoration: const InputDecoration(
                labelText: "Service Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addRate,
                icon: const Icon(Icons.add),
                label: const Text("Add to Rate List"),
              ),
            ),
            const Divider(height: 30),

            Expanded(
              child: widget.providerData.rateList.isEmpty
                  ? const Center(child: Text("No services added yet"))
                  : ListView.builder(
                      itemCount:  widget.providerData.rateList.length,
                      itemBuilder: (context, index) {
                        final item =  widget.providerData.rateList[index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.design_services),
                            title: Text(item['service']),
                            subtitle: Text("Price: ${item['price']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // IconButton(
                                //   icon: const Icon(Icons.edit, color: Colors.blue),
                                //   onPressed: () => _editRate(index),
                                // ),
                                // IconButton(
                                //   icon: const Icon(Icons.delete, color: Colors.red),
                                //   onPressed: () => _deleteRate(index),
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
