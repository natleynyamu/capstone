// import 'package:flutter/material.dart';
// import 'package:slot_seek/app_colors.dart';
// import 'package:slot_seek/custom_widgets.dart';

// class ChangePassword extends StatelessWidget {
//   const ChangePassword({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String newPassword = '';

//     // Variable to store the new name
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.0),
//         gradient: const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             AppColors.primaryGradientStart,
//             AppColors.primaryGradientEnd,
//           ],
//         ),
//       ),
//       child: AlertDialog(
//         title: const Text('Change Password',style: TextStyle(color: AppColors.primaryColor),),
//         contentPadding:const  EdgeInsets.symmetric(vertical: 12),
//         content: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 cursorColor: AppColors.secondaryColor,
//                 onChanged: (value) {
//                   newPassword =
//                       value; // Update the new name when the user types
//                 },
//                 decoration: const InputDecoration(
//                   labelText: ' Old Password',
//                   labelStyle: TextStyle(
//                     color: AppColors.greyMedium,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                       color: AppColors.secondaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//               TextFormField(
//                 cursorColor: AppColors.secondaryColor,
//                 onChanged: (value) {
//                   newPassword =
//                       value; // Update the new name when the user types
//                 },
//                 decoration: const InputDecoration(
//                   labelText: ' New Password',
//                   labelStyle: TextStyle(
//                     color: AppColors.greyMedium,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                       color: AppColors.secondaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//               TextFormField(
//                 cursorColor: AppColors.secondaryColor,
//                 onChanged: (value) {
//                   newPassword =
//                       value; // Update the new name when the user types
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Confirm New Password',
//                   labelStyle: TextStyle(
//                     color: AppColors.greyMedium,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                       color: AppColors.secondaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     // Close the dialog
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(color: AppColors.secondaryColor),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ), // Disable the save button if password is empty
//                 PrimaryElevatedButton(
//                   onPressed: newPassword.isNotEmpty
//                       ? () {
//                           // Perform the edit operation with the new password
//                           // For example, you can update the user's password

//                           // Close the dialog
//                           Navigator.of(context).pop();
//                         }
//                       : null,
//                   text: 'Save',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slot_seek/custom/app_colors.dart';
import 'package:slot_seek/custom/custom_widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          'Change Password',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                obscureText: true,
                controller: _oldPasswordController,
                labelText: 'Old Password',
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
                obscureText: true,
                controller: _newPasswordController,
                labelText: 'New Password',
                validator: (newPassword) {
                  if (newPassword == null || newPassword.isEmpty) {
                    return 'Please enter a password';
                  } else if (newPassword.length < 6) {
                    return 'Password must be at least 6 characters long';
                  } else if (!newPassword.contains(RegExp(r'[A-Z]'))) {
                    return 'Password must contain at least one uppercase letter';
                  } else if (!newPassword.contains(RegExp(r'[a-z]'))) {
                    return 'Password must contain at least one lowercase letter';
                  } else if (!newPassword.contains(RegExp(r'[0-9]'))) {
                    return 'Password must contain at least one digit';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                obscureText: true,
                controller: _confirmNewPasswordController,
                labelText: 'Confirm New Password',
                validator: (passwordConfirm) {
                  if (passwordConfirm == null || passwordConfirm.isEmpty) {
                    return 'Please confirm your password';
                  } else if (passwordConfirm != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
        //actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(
            width: 20,
          ),
          PrimaryElevatedButton(
            onPressed: () async {
              // Perform the password change operation
              String oldPassword = _oldPasswordController.text;
              String newPassword = _newPasswordController.text;
              String confirmNewPassword =
                  _confirmNewPasswordController.text;

              if (newPassword == confirmNewPassword) {
                try {
                  final user = _auth.currentUser;
                  if (user != null) {
                    // Re-authenticate the user
                    final credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: oldPassword,
                    );
                    await user.reauthenticateWithCredential(credential);

                    // Update the user's password
                    await user.updatePassword(newPassword);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password changed successfully')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to change password: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('New passwords do not match')),
                );
              }
            },
            text: 'Save',
          ),
        ],
      ),
    );
  }
}
