import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slot_seek/custom/app_colors.dart';
import 'package:slot_seek/app/home.dart';
import 'package:slot_seek/auth/sign_up.dart';
import 'package:slot_seek/custom/success_dialog.dart';

import '../custom/custom_widgets.dart';
import 'email_verification.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Future signIn() async {
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim());
  // }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }  


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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Log in with your email and password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: _emailController,
                              labelText: 'Email',
                              validator: (email) {
                                if (email == null || email.isEmpty) {
                                  return 'Please enter an email address';
                                } else if ((!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(email))) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: _passwordController,
                              labelText: 'Password',
                              obscureText: true,
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return 'Please enter a password';
                                } else if (password.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                } else if (!password.contains(RegExp(r'[A-Z]'))) {
                                  return 'Password must contain at least one uppercase letter';
                                } else if (!password.contains(RegExp(r'[a-z]'))) {
                                  return 'Password must contain at least one lowercase letter';
                                } else if (!password.contains(RegExp(r'[0-9]'))) {
                                  return 'Password must contain at least one digit';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: 300,
                              height: 60,
                              child: PrimaryElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Perform login
                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      );
                                      // Navigate to success page or show success dialog
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const SuccessDialog(
                                            successMessage:
                                                'Logged In Successfully',
                                            buttonText: 'Continue',
                                            messageDetail:
                                                'You have successfully logged in.',
                                          );
                                        },
                                      ); // Navigate to the homepage
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const HomePage(),
                                        ),
                                      );
                                    } catch (e) {
                                      // Show error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Center(
                                            child: Text(
                                              'Invalid Username or Password!',
                                              style: TextStyle(
                                                  color: AppColors.errorColor),
                                            ),
                                          ),
                                          backgroundColor: AppColors.greyLight,
                                        ),
                                      );
                                    }
                                  }
                                },
                                text: 'Log In',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const ForgotPasswordEmailVerification(),
                        ));
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            // Navigate to the registration page
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ));
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          BackButtonWidget(context: context),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
