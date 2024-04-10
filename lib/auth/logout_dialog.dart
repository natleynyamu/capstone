import 'package:flutter/material.dart';
import 'package:slot_seek/custom/app_colors.dart';
import 'package:slot_seek/loading/get_started.dart';
 
import 'package:firebase_auth/firebase_auth.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
      ),
      child: AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Dismiss the dialog
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform logout action
              // For example, navigate to the login page
              signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

final FirebaseAuth auth = FirebaseAuth.instance;

  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const GetStartedPage()));
  }
}
