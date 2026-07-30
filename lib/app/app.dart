import 'package:flutter/material.dart';

class TripSyncApp extends StatelessWidget {
  const TripSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripSync',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('TripSync')),
      ),
    );
  }
}
