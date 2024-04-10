import 'package:flutter/material.dart';
import 'package:slot_seek/custom/app_colors.dart';
import 'package:slot_seek/custom/custom_widgets.dart';
import 'package:slot_seek/auth/login.dart';
import 'package:slot_seek/auth/sign_up.dart';

class SignInRequiredPage extends StatelessWidget {
  const SignInRequiredPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              Expanded(
                  child: Text(
                'Sign In Required',
                textAlign: TextAlign.center,
              )),
            ],
          ),
          backgroundColor: AppColors.primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You need to sign in or create an account to access this feature.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 280,
                  height: 50,
                  child: PrimaryElevatedButton(
                    text: 'Log In',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to the SignUp page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
