import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slot_seek/app_colors.dart';
import 'package:slot_seek/custom_widgets.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldEmail = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd
          ],
        ),
      ),
      child: AlertDialog(
        contentPadding:
            const EdgeInsets.fromLTRB(24, 20, 24, 0), // Adjust padding
        title: const Text(
          'Change Email',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: Column(
            mainAxisSize: MainAxisSize.min, // Set to minimize height
            children: [
              CustomTextFormField(
                controller: _oldEmail,
                labelText: 'Enter old Email',
                validator: (oldEmail) {
                  if (oldEmail == null || oldEmail.isEmpty) {
                    return 'Please enter an email address';
                  } else if ((!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(oldEmail))) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                obscureText: true,
                controller: _passwordController,
                labelText: 'Enter Password',
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
              CustomTextFormField(
                controller: _newEmail,
                labelText: 'Enter new Email',
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Please enter an email address';
                  } else if ((!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(email))) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ]),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryColor),
            ),
          ),
          PrimaryElevatedButton(
            onPressed: () async {
              String oldEmail = _oldEmail.text.trim();
              String password = _passwordController.text.trim();
              String newEmail =
                  _newEmail.text.trim(); // Variable to store the new email

              if (_formKey.currentState!.validate()) {
                await changeEmail(oldEmail, password, newEmail);
              }
              // Perform the edit operation with the new email
              // For example, you can update the user's profile with the new email

              // Close the dialog
              Navigator.of(context).pop();
            },
            text: 'Save',
          ),
        ],
      ),
    );
  }

  Future<void> changeEmail(String oldEmail, String password, String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Re-authenticate the user
        final credential = EmailAuthProvider.credential(
          email: oldEmail,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        // Update the user's email
        await user.updateEmail(newEmail);
        print('Email has been changed');
      } else {
        print("No user is signed in.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // Handle the case where the email is incorrect
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        // Handle the case where the password is incorrect
      }
    } catch (e) {
      print('Failed to change email: $e');
      // Handle other types of errors
    }
  }
}
