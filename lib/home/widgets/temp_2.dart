import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/image_data.dart';
import 'image_data_widget.dart';

class temp2 extends StatefulWidget {
  @override
  _temp2State createState() => _temp2State();
}

class _temp2State extends State<temp2> with SingleTickerProviderStateMixin {
  final pageController = PageController(viewportFraction: 0.85);
  int pageIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Add haptic feedback when changing pages
    pageController.addListener(() {
      if (pageController.page?.round() != pageIndex) {
        HapticFeedback.lightImpact();
      }
    });
    
    // Create bouncing animation for welcome text
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
       
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: PageView.builder(
            controller: pageController,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return LocationWidget(location: location);
            },
            onPageChanged: (index) => setState(() => pageIndex = index),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              locations.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 10,
                width: pageIndex == index ? 24 : 10,
                decoration: BoxDecoration(
                  color: pageIndex == index
                      ? theme.colorScheme.secondary
                      : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        Text(
          'Swipe to see more!',
          style: GoogleFonts.fredoka(
            fontSize: 14,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8)
      ],
    );
  }
}
