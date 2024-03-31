import 'package:flutter/material.dart';
import 'package:slot_seek/app_colors.dart';
import 'package:slot_seek/custom_widgets.dart';
import 'package:slot_seek/success_dialog.dart';


class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: RadialGradient(colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd
            ])),
            child: Stack(children: [
              BackButtonWidget(context: context),
              const Positioned(
                top: 20,
                right: 20,
                child: Text(
                  'SlotSeek',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/password_solid.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Change Password',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          width: 320,
                          child: Text(
                            'Please ensure that this new password meets the criterion needed',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(controller: _passwordController,
                                labelText: 'New Password',
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
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                labelText: 'Confirm Password',
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
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 50,
                          width: 290,
                          child: PrimaryElevatedButton(
                            onPressed: () { // Validate the form
                                  if (_formKey.currentState!.validate()) {
                                    // Form is valid, continue with signup process
                                  }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const SuccessDialog(
                                    buttonText: 'Log In to continue',
                                    successMessage: 'Password change Successful!', messageDetail:  'You have successfully changed password! Please use the newly created password when logging in'
                                  );
                                },
                              );
                            },
                            text: 'Save',
                          ),
                        ),
                      ],
                    ),
                  )))
            ])));
  }
}
