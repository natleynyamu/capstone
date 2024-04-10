import 'package:flutter/material.dart';
import 'package:slot_seek/custom/custom_widgets.dart';
import 'package:slot_seek/app/home.dart';
import 'package:slot_seek/auth/login.dart';
import 'package:slot_seek/auth/sign_up.dart';
import '../custom/app_colors.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.30, 0.86),
                radius: 0.06,
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primaryGradientEnd
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment(20, 20),
            child: Text(
              'SlotSeek',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/get_started.png'),
                      const SizedBox(height: 10),
                      const Text(
                        'Almost there',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'It is now time to choose your way forward with SlotSeek!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(height: 60,width: 280,
                        child: OutlinedButton(
                          onPressed: () {
                            // Add your onPressed logic here
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            side: const BorderSide(color: AppColors.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal:
                                    20), // Adjust the vertical padding here
                          ),
                          child: const Text(
                            'Open Without an account',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        width: 280,
                        child: PrimaryElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          text: 'Sign In',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        // Move Center widget here
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Align Row items center horizontally
                          children: [
                            const Text(
                              'Do not have an Account?',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignupPage(),
                                ));
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
