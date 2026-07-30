import 'package:flutter/material.dart';

/// C.5 Home / Dashboard stub — real content added in Phase 4.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('TripSync')),
    body: const Center(child: Text('Home')),
  );
}
