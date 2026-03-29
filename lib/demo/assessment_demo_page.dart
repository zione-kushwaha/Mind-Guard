import 'package:flutter/material.dart';
import '../app/view/category_selection_screen.dart';

class AssessmentDemoPage extends StatelessWidget {
  const AssessmentDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          'Assessment Demo',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const CategorySelectionScreen(),
    );
  }
}
