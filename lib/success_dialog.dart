import 'package:flutter/material.dart';
import 'package:slot_seek/login.dart';

import 'app_colors.dart';
import 'custom_widgets.dart';

class SuccessDialog extends StatelessWidget {
  final String successMessage;
  final String buttonText;
  final String messageDetail;

  const SuccessDialog({super.key, 
    required this.successMessage,
    required this.messageDetail,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        width: 350,
        height: 414,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: const RadialGradient(colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(
                    color: AppColors.secondaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/success.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  successMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: Text(
                    messageDetail,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: PrimaryElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                    },
                    text: buttonText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
