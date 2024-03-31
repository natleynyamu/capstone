// import 'package:flutter/material.dart';
// import 'package:slot_seek/app_colors.dart';
// import 'package:slot_seek/custom_widgets.dart';

// class FeedbackDialog extends StatelessWidget {
//   const FeedbackDialog({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String feedback = ''; // Variable to store the feedback

//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             AppColors.primaryGradientStart,
//             AppColors.primaryGradientEnd
//           ],
//         ),
//       ),
//       child: AlertDialog(
//         contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0), // Adjust padding
//         title: const Text('Leave Feedback',
//           style: TextStyle(color: AppColors.primaryColor),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min, // Set to minimize height
//           children: [
//             TextFormField(
//               cursorColor: AppColors.secondaryColor,
//               onChanged: (value) {
//                 feedback = value; // Update the feedback when the user types
//               },
//               maxLines: 5, // Allow multiple lines for feedback
//               decoration: const InputDecoration(
//                 labelText: 'Enter your feedback',
//                 labelStyle: TextStyle(
//                   color: AppColors.greyMedium,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(
//                     color: AppColors.secondaryColor,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               // Close the dialog
//               Navigator.of(context).pop();
//             },
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: AppColors.secondaryColor),
//             ),
//           ),
//           PrimaryElevatedButton(
//             onPressed: () {
//               // TODO: Handle the feedback submission
//               //print('Feedback submitted: $feedback');

//               // Close the dialog
//               Navigator.of(context).pop();
//             },
//             text: 'Submit',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:slot_seek/app_colors.dart';
import 'package:slot_seek/custom_widgets.dart';

class FeedbackDialog extends StatelessWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String feedback = ''; // Variable to store the feedback

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
          'Leave Feedback',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Set to minimize height
          children: [
            TextFormField(
              cursorColor: AppColors.secondaryColor,
              onChanged: (value) {
                feedback = value; // Update the feedback when the user types
              },
              maxLines: 5, // Allow multiple lines for feedback
              decoration: const InputDecoration(
                labelText: 'Enter your feedback',
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
          ],
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
              // Check if the feedback is not empty
              if (feedback.isNotEmpty) {
                // Get the current user's ID
                String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

                // Submit feedback to Firestore
                bool success =
                    await FeedbackService.submitFeedback(feedback, userId);

                // Show a SnackBar message based on the success status
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Feedback sent successfully!'
                          : 'Failed to send feedback. Please try again later.',
                    ),
                    backgroundColor:
                        success ? AppColors.primaryColor : AppColors.errorColor,
                    behavior: SnackBarBehavior.floating, // Push to the top
                  ),
                );

                // Close the dialog
                Navigator.of(context).pop();
              } else {
                // Show a SnackBar message indicating that feedback is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Feedback cannot be empty. Please enter your feedback.',
                    ),
                    backgroundColor: AppColors.errorColor,
                    behavior: SnackBarBehavior.floating, // Push to the top
                  ),
                );
              }
            },
            text: 'Submit',
          ),
        ],
      ),
    );
  }

  // Method to submit feedback to Firestore
  Future<void> submitFeedback(String feedback) async {
    try {
      // Get a reference to the feedback collection
      CollectionReference feedbackCollection =
          FirebaseFirestore.instance.collection('feedback');

      // Create a new document in the feedback collection
      await feedbackCollection.add({'feedback': feedback});
    } catch (e) {
      // Handle errors
      print('Error submitting feedback: $e');
    }
  }
}

class FeedbackService {
  static Future<bool> submitFeedback(String feedback, String userId) async {
    try {
      // Get a reference to the feedback collection
      CollectionReference feedbackCollection =
          FirebaseFirestore.instance.collection('feedback');

      // Create a new document in the feedback collection with the user's ID and timestamp
      await feedbackCollection.add({
        'feedback': feedback,
        'userId': userId, // Include the user's ID in the document
        'timestamp':
            FieldValue.serverTimestamp(), // Include the server timestamp
      });

      // Return true indicating success
      return true;
    } catch (e) {
      // Handle errors
      print('Error submitting feedback: $e');
      // Return false indicating failure
      return false;
    }
  }
}
