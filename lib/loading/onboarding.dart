import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slot_seek/custom/app_colors.dart';
import 'package:slot_seek/loading/get_started.dart';
import 'package:slot_seek/custom/custom_widgets.dart'; // Import the primary elevated button

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [const SizedBox(height:20,),
          Row(
            children: const [
              SizedBox(
                width: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'SlotSeek',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildPage(
                  'Seek Slots',
                  'Tired of circling the airport parking lot endlessly? Say goodbye to parking headaches with Slot Seek – your ultimate companion for seamless, stress-free parking at Mugabe Airport!',
                  'assets/images/onboarding_1.png',
                ),
                _buildPage(
                  'Smart. Swift',
                  'Slot Seek harnesses cutting-edge technology to transform your parking experience. No more guessing games - effortlessly locate the nearest available parking slots with just a tap on your screen.',
                  'assets/images/onboarding_2.png',
                ),
                _buildPage(
                  'Precision',
                  "Navigate Mugabe Airport's vast parking areas with pinpoint accuracy. Slot Seek guides you directly to open spaces, saving you time and energy. Bid farewell to aimless driving and hello to efficient parking!",
                  'assets/images/onboarding_3.png',
                ),
                _buildPage(
                  'Secure a slot',
                  "Worried about the safety of your vehicle? Slot Seek not only helps you find parking but also prioritizes security. Discover well-monitored and well-lit spaces for a worry-affordable parking experience.",
                  'assets/images/onboarding_4.png',
                ),
              ],
            ),
          ),
          _buildDotsIndicator(),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildPage(String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 4; i++)
          Container(
            margin: const EdgeInsets.all(5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == i
                  ? AppColors.primaryColor
                  : AppColors.greyMedium,
            ),
          ),
      ],
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextButton(
          onPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          child: const Text(
            'Previous',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
              height: 0.06,
            ),
          ),
        ),
        _currentPage < 3
            ? PrimaryElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                text: 'Next',
              )
            : PrimaryElevatedButton(
                onPressed: () {
                  _completeOnboarding(); // Mark onboarding as completed
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GetStartedPage(),
                    ),
                  );
                },
                text: 'Get Started',
              ),
      ]),
    );
  }

  // Mark onboarding as completed
  void _completeOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
  }
}

void main() {
  runApp(const MaterialApp(
    home: OnboardingScreen(),
  ));
}
