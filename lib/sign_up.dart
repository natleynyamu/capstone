import 'package:flutter/material.dart';
import 'package:slot_seek/app_colors.dart';
import 'package:slot_seek/login.dart';
import 'package:slot_seek/success_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    // Store the context before the async operation
    final BuildContext dialogContext = context;

    try {
      // Step 1: Create user in Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      try {
        // Firestore write operation
        // Step 2: Save additional user information (name) to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text
              .trim(), // Assuming _nameController is defined
          'email': _emailController.text.trim(),
          // Add other fields as needed
        });

        // User signed up successfully, show success dialog
        // ignore: use_build_context_synchronously
        showDialog(
          context: dialogContext, // Use the stored context here
          builder: (BuildContext context) {
            return const SuccessDialog(
              successMessage: 'Account created Successfully',
              buttonText: 'Log In to continue',
              messageDetail:
                  'You have successfully created your account. Log in to continue and interact with the application',
            );
          },
        );
      } catch (e) {
        // Show the error message using a SnackBar
        // ignore: use_build_context_synchronously
        print(e);
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'An error occured while creating an account',
                style: TextStyle(color: AppColors.errorColor),
              ),
            ),
            backgroundColor: AppColors.greyLight,
          ),
        );
      }
    } catch (e) {
      print(e);
      // Handle signup error (show message, etc.) using the original context
      String errorMessage =
          'An error occurred while signing up. Please try again.';

      // Check the type of error and provide specific error messages
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'An account already exists for that email.';
            break;

          default:
            errorMessage =
                'An error occurred while signing up. Please try again later.';
            break;
        }
      } // Show the error message using a SnackBar
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          ),
          backgroundColor: AppColors.greyLight,
        ),
      );
    }
  }

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
                    Image.asset('assets/images/sign_up.png'),
                    const Text(
                      'Create an account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      width: 300,
                      child: Text(
                        'Create an account to see and experience more features of this application',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: _nameController,
                              labelText: 'Full Name',
                              validator: (name) {
                                if (name == null || name.isEmpty) {
                                  return 'Please enter your name';
                                  // } else if (name.length < 6) {
                                  //   return 'Name should be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                              labelText: 'Password',
                              obscureText: true,
                              controller: _passwordController,
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return 'Please enter a password';
                                } else if (password.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                } else if (!password
                                    .contains(RegExp(r'[A-Z]'))) {
                                  return 'Password must contain at least one uppercase letter';
                                } else if (!password
                                    .contains(RegExp(r'[a-z]'))) {
                                  return 'Password must contain at least one lowercase letter';
                                } else if (!password
                                    .contains(RegExp(r'[0-9]'))) {
                                  return 'Password must contain at least one digit';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              labelText: 'Confirm Password',
                              obscureText: true,
                              validator: (passwordConfirm) {
                                if (passwordConfirm == null ||
                                    passwordConfirm.isEmpty) {
                                  return 'Please confirm your password';
                                } else if (passwordConfirm !=
                                    _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 300,
                                height: 60,
                                child: PrimaryElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await _signUp();
                                    }
                                  },
                                  text: 'Sign Up',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an Account?',
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
                              builder: (context) => const LoginPage(),
                            ));
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
}
