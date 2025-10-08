import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



class Register extends StatefulWidget {
  

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {


  Widget build(BuildContext){
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 2, 52, 94),
        foregroundColor: Colors.white,
        title: Column(
          children: [
            Center(),
            Text("Hazir",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
              ),
            ),
            Text("Bhai Hazir hai!",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold
              ),
            ),
            

          ],
        ),
      )

    );
  }


}