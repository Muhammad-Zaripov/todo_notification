// on top
import 'package:flutter/material.dart';

import '../../../core/utils/app_images.dart';
import '../widgets/onbording_items.dart';
import 'start_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': AppImages.onbord1,
      'title': 'Welcome to UpTodo',
      'subtitle': 'Your tasks, organized and simplified.',
    },
    {
      'image': AppImages.onbord2,
      'title': 'Track Your Progress',
      'subtitle': 'Stay productive every day!',
    },
    {
      'image': AppImages.onbord3,
      'title': 'Achieve Your Goals',
      'subtitle': 'Focus on what matters most.',
    },
  ];

  void _goToNextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          if (_currentPage != onboardingData.length - 1)
            TextButton(
              onPressed: _finishOnboarding,
              child: const Text('SKIP', style: TextStyle(color: Colors.black)),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OnboardingItem(
                    image: data['image']!,
                    title: data['title']!,
                    subtitle: data['subtitle']!,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.black : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage != 0)
                  TextButton(
                    onPressed: _goToPreviousPage,
                    child: const Text('BACK'),
                  )
                else
                  const SizedBox(width: 60),
                ElevatedButton(
                  onPressed: _goToNextPage,
                  child: Text(
                    _currentPage == onboardingData.length - 1
                        ? 'GET STARTED'
                        : 'NEXT',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
