import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication/login.dart';
import 'provider/provider_screen.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = Color.fromRGBO(2,62,138,1);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
      ),
      // home: const MyHomePage(),
      // home: ConsumerScreen(),
      // home: Register(),
      // home: ProviderScreen(),
      home: LoginScreen(),
      // home: SignUpScreen(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Map Check"),
      ),

    );

  }
}
