import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slot_seek/custom/app_colors.dart';
import 'package:slot_seek/custom/custom_widgets.dart';

class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newName = ''; // Variable to store the new name

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
          'Edit Profile Name',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: TextFormField(
          cursorColor: AppColors.secondaryColor,
          onChanged: (value) {
            newName = value; // Update the new name when the user types
          },
          decoration: const InputDecoration(
            labelText: 'Enter New Name',
            labelStyle: TextStyle(
              color: AppColors.greyMedium,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
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
              try {
                // Get the current user
                User? user = FirebaseAuth.instance.currentUser;

                // Update the display name in Firebase Authentication
                await user?.updateDisplayName(newName);

                // Update the user document in Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .update({
                  'name': newName,
                });

                // Optionally, reload the user profile to reflect the changes
                await user?.reload();

                // Show success message
                const SnackBar(
                  content: Center(
                    child: Text(
                      'Profile name updated successfully.',
                      style: TextStyle(color: AppColors.textLightorange),
                    ),
                  ),
                  backgroundColor: AppColors.primaryColor,
                  behavior:
                      SnackBarBehavior.floating, // Set behavior to floating
                  margin: EdgeInsets.only(
                      bottom: 20), // Adjust the margin as needed
                );
              } catch (e) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update profile name: $e')),
                );
              }

              // Close the dialog
              Navigator.of(context).pop();
            },
            text: 'Save',
          ),
        ],
      ),
    );
  }
}
