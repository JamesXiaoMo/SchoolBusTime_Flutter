import 'package:flutter/material.dart';

class SpecialThanksPage extends StatelessWidget {
  const SpecialThanksPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Special Thanks"),
        backgroundColor: Colors.green,
      ),
      body:
      Container(
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}