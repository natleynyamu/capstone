import 'package:flutter/material.dart';
import 'package:slot_seek/app_colors.dart';
import 'package:slot_seek/custom_widgets.dart';
import 'package:slot_seek/password_reset.dart';

class ForgotPasswordVerificationCode extends StatelessWidget {
  const ForgotPasswordVerificationCode({super.key});

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
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/padlock.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Verification Code',
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
                          'Please enter the 4-digit code sent to your email',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInputSpace(),
                          const SizedBox(width: 10),
                          _buildInputSpace(),
                          const SizedBox(width: 10),
                          _buildInputSpace(),
                          const SizedBox(width: 10),
                          _buildInputSpace(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 320,
                        child: TextButton(
                          onPressed: () {
                            // Add your onPressed logic here
                            //Navigator.of(context).push(MaterialPageRoute(
                            //  builder: (context) => const ForgotPasswordEmailVerification(),
                           // ));
                          },
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: 290,
                        child: PrimaryElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PasswordReset(),
                            ));
                          },
                          text: 'Verify',
                        ),
                      ),
                    ],
                  )))
            ])));
  }

  Widget _buildInputSpace() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
    );
  }
}
