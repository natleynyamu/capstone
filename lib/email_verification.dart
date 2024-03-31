import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slot_seek/app_colors.dart';
import 'package:slot_seek/custom_widgets.dart';


class ForgotPasswordEmailVerification extends StatefulWidget {
  const ForgotPasswordEmailVerification({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordEmailVerification> createState() =>
      _ForgotPasswordEmailVerificationState();
}

class _ForgotPasswordEmailVerificationState
    extends State<ForgotPasswordEmailVerification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false; // Track loading state

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Password reset email sent successfully.')),
          backgroundColor: AppColors.primaryColor),
        
      );
      
    } on FirebaseAuthException catch (e) {
      String message =
          'Failed to send password reset email. Please try again later.';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.errorColor,
        ),
      );
      print('Error sending password reset email: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Stack(
          children: [
            BackButtonWidget(context: context),
            const Positioned(
              top: 40,
              right: 40,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/email.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Email Verification',
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
                        'Please enter the email address associated with your account',
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
                      child: Container(
                        width: 320,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          //color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomTextFormField(
                          controller: _emailController,
                          labelText: 'Enter your email',
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
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: 290,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primaryColor,
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await passwordReset();
                          }
                        
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.secondaryLight,
                              )
                            : const Text(
                                'Reset Password',
                                style:
                                    TextStyle(color: AppColors.textLightorange),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
