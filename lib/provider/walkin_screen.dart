import 'package:flutter/material.dart';

class Walkin extends StatefulWidget {
  const Walkin({super.key});

  @override
  State<Walkin> createState() => _WalkinState();
}

class _WalkinState extends State<Walkin> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedService;
  String _prepaid = 'No'; 

  List<String> services = ['Haircut — Rs. 800', 'Beard Trim — Rs. 400']; 
  List<String> prepaidOptions = ['Yes', 'No'];


List<Map<String, String>> recentWalkins = [];

  void _addWalkin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        recentWalkins.add({
          'name': _nameController.text.trim(),
          'service': _selectedService!,
          'prepaid': _prepaid,
          'notes': _notesController.text.trim(),
        });

        _nameController.clear();
        _notesController.clear();
        _selectedService = null;
        _prepaid = 'No';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer added to queue!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, 

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Add Walk-in Customer",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Customer name",
                  hintText: "e.g., Ali Khan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter customer name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: InputDecoration(
                  labelText: "Service",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: services
                    .map((service) => DropdownMenuItem(
                          value: service,
                          child: Text(service),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedService = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Please select a service" : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [

                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: "Notes",
                        hintText: "optional",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _prepaid,
                      decoration: InputDecoration(
                        labelText: "Prepaid?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: prepaidOptions
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _prepaid = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addWalkin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Add to Queue",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "Recent Walk-ins",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),

              if (recentWalkins.isEmpty)
                const Text(
                  "No recent walk-ins yet.",
                  style: TextStyle(color: Colors.black45),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentWalkins.length,
                  itemBuilder: (context, index) {
                    final customer = recentWalkins[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[200],
                          child: Text(
                            customer['name']![0].toUpperCase(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        title: Text(customer['name'] ?? ''),
                        subtitle: Text(customer['service'] ?? ''),
                        trailing: Text(
                          customer['prepaid'] == 'Yes' ? 'Prepaid' : 'Pay Later',
                          style: TextStyle(
                            color: customer['prepaid'] == 'Yes'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
