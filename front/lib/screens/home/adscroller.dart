import 'package:flutter/material.dart';
import 'dart:async';

class AdsScroller extends StatefulWidget {
  const AdsScroller({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdsScrollerState createState() => _AdsScrollerState();
}

class _AdsScrollerState extends State<AdsScroller> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _images = [
    'assets/images/ss1.jpg',
    'assets/images/ss2.jpeg',
    'assets/images/ss3.jpg',
    'assets/images/ss4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // Start auto-scroll
    Future.delayed(Duration.zero, _startAutoScroll);
  }

  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return; // Prevent errors when widget is disposed
      setState(() {
        _currentPage = (_currentPage + 1) % _images.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}