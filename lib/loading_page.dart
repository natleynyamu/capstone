import 'dart:async';
import 'package:flutter/material.dart';
import 'package:slot_seek/app_colors.dart';
import 'package:slot_seek/get_started.dart';
import 'package:slot_seek/onboarding.dart'; // Import the primary elevated button

void main() {
  runApp(const MaterialApp(
    home: LoadingPage(),
  ));
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Timer to delay the navigation decision
    Timer(const Duration(seconds: 4), () {
      // Check if the user has completed onboarding
      bool onboardingCompleted = checkOnboardingCompleted();

      // Navigate to the appropriate screen based on onboarding completion status
      if (onboardingCompleted) {
        // Navigate to the get started page
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const GetStartedPage(),
        ));
      } else {
        // Navigate to the onboarding screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ));
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background picture
          Image.asset(
            'assets/images/luxurious-car.jpg',
            fit: BoxFit.cover,
          ),
          // Loading indicator centered on the screen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // Text slightly below the center of the screen
                SizedBox(
                    height: 300), // Adjust the height for vertical positioning
                Text(
                  'Slot Seek',
                  style:
                      TextStyle(fontSize: 64, color: AppColors.textLightblue),
                ),
                SizedBox(height: 10), // Add space between the texts
                Text(
                  'Your Slot, Found Fast',
                  style:
                      TextStyle(fontSize: 20, color: AppColors.textLightblue),
                ),
              ],
            ),
          ),
          // Loading indicator
          Positioned(
            bottom: 30, // Adjust bottom position
            right: 20, // Adjust right position
            child: Row(
              children: const [
                Text(
                  'Loading', // Initial text
                  style:
                      TextStyle(fontSize: 32, color: AppColors.textLightblue),
                ),
                SizedBox(
                    width: 5), // Add some spacing between the text and dots
                // Three dots animation
                LoadingDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to check if onboarding has been completed
  bool checkOnboardingCompleted() {
    // You can implement the logic to check if onboarding has been completed
    // For example, you can use shared preferences or any other persistent storage mechanism
    // Return true if onboarding has been completed, false otherwise
    return false; // For demonstration purposes, always returns false
  }
}

class LoadingDots extends StatefulWidget {
  const LoadingDots({Key? key}) : super(key: key);

  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) {
          return Padding(
            padding: EdgeInsets.only(
                right: index != 2 ? 8 : 0), // Increase padding for bigger dots
            child: FadeTransition(
              opacity: _controller.drive(
                CurveTween(
                  curve: Interval(
                    (index + 1) / 3 * 2 / 3,
                    1.0,
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
              child: const Text('.',
                  style: TextStyle(
                      color: AppColors.textLightblue,
                      fontSize: 28)), // Increase font size for bigger dots
            ),
          );
        },
      ),
    );
  }
}
