import 'package:flutter/material.dart';

class PlaceHolderScreen extends StatefulWidget {
  const PlaceHolderScreen({super.key});

  @override
  State<PlaceHolderScreen> createState() => _PlaceHolderScreenState();
}

class _PlaceHolderScreenState extends State<PlaceHolderScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Feature Coming Soon.'),
      ),
    );
  }
}
