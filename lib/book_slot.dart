import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slot_seek/app_colors.dart';
import 'package:slot_seek/custom_widgets.dart';

class BookSlotPage extends StatefulWidget {
  final String slotId;
  const BookSlotPage({Key? key, required this.slotId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookSlotPageState createState() => _BookSlotPageState();
}

class _BookSlotPageState extends State<BookSlotPage> {
  bool _isTimeSelected = false;
  bool _isEndTimeSelected = false;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(
      const Duration(hours: 1))); // Default end time 1 hour after start time
  DateTime peakStart = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 30);
  DateTime peakEnd = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 00);

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
          const Duration(days: 365)), // Allow booking up to one year in advance
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  // Future<void> _selectEndDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _endDate ?? DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime.now().add(const Duration(days: 365)),
  //   );

  //   if (picked != null && picked != _endDate) {
  //     DateTime newEndDate = picked;
  //     // Check if the end time is less than 20 minutes after the start time
  //     if (_startDate != null &&
  //         newEndDate.isBefore(_startDate!.add(const Duration(minutes: 20)))) {
  //       // If the end time is less than 20 minutes after the start time,
  //       // set the end date to be at least one day after the start date
  //       //newEndDate = _startDate!.add(Duration(days: 1));
  //     }
  //     setState(() {
  //       _endDate = newEndDate;
  //     });
  //   }
  // }
Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _endDate) {
      // Check if the picked end date is the same as or after the start date
      if (_startDate != null && picked.isAfter(_startDate!) ||
          picked.isAtSameMomentAs(_startDate!)) {
        setState(() {
          _endDate = picked;
        });
      } else {
        // Optionally, show a message to the user if the end date is not valid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'End date must be after the start date.',
              style: TextStyle(color: AppColors.textLightblue),
              textAlign: TextAlign.center,
            ),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating, // Set behavior to floating
            margin: EdgeInsets.only(bottom: 20), // Adjust the margin as needed
          ),
        );
      }
    }
  }


  // Future<void> _selectEndTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     builder: (context, childWidget) {
  //       return MediaQuery(
  //         data: MediaQuery.of(context).copyWith(
  //           alwaysUse24HourFormat: true,
  //         ),
  //         child: childWidget!,
  //       );
  //     },
  //   );

  //   if (picked != null) {
  //     // Convert the picked TimeOfDay to a DateTime object for comparison
  //     DateTime pickedDateTime = DateTime(
  //       _endDate!.year,
  //       _endDate!.month,
  //       _endDate!.day,
  //       picked.hour,
  //       picked.minute,
  //     );

  //     // Convert the start time to a DateTime object for comparison
  //     DateTime startDateTime = DateTime(
  //       _startDate!.year,
  //       _startDate!.month,
  //       _startDate!.day,
  //       _startTime.hour,
  //       _startTime.minute,
  //     );

  //     // Check if the picked end time is at least 20 minutes after the start time
  //     // and also ensure it's not before the start time on the same day
  //     if (pickedDateTime
  //             .isAfter(startDateTime.add(const Duration(minutes: 20))) &&
  //         pickedDateTime.isAfter(startDateTime) &&
  //         pickedDateTime.isAfter(DateTime.now())) {
  //       setState(() {
  //         _endTime = picked;
  //         _isEndTimeSelected =
  //             true; // Set the flag to true when a time is selected
  //       });
  //     } else {
  //       // Optionally, show a message to the user if the end time is not valid
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             'End time must be after the start time and at least 20 minutes after.',
  //           style: TextStyle(color: AppColors.textLightblue),
  //             textAlign: TextAlign.center,
  //           ),
  //           backgroundColor: AppColors.errorColor,
  //           behavior: SnackBarBehavior.floating, // Set behavior to floating
  //           margin: EdgeInsets.only(bottom: 20), // Adjust the margin as needed
  //         ),
  //       );
  //     }
  //   }
  // }

Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: childWidget!,
        );
      },
    );

    if (picked != null) {
      // Convert the picked TimeOfDay to a DateTime object for comparison
      DateTime pickedDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        picked.hour,
        picked.minute,
      );

      // Convert the start time to a DateTime object for comparison
      DateTime startDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime.hour,
        _startTime.minute,
      );

      // Check if the picked end time is at least 20 minutes after the start time
      // and also ensure it's not before the start time on the same day
      // Additionally, ensure it's after the current time of the selected end date
      if (pickedDateTime
              .isAfter(startDateTime.add(const Duration(minutes: 20))) &&
          pickedDateTime.isAfter(startDateTime) &&
          pickedDateTime.isAfter(DateTime.now())) {
        setState(() {
          _endTime = picked;
          _isEndTimeSelected =
              true; // Set the flag to true when a time is selected
        });
      } else {
        // Optionally, show a message to the user if the end time is not valid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'End time must be after the start time, at least 20 minutes after, and after the current time of the selected date.',
              style: TextStyle(color: AppColors.textLightblue),
              textAlign: TextAlign.center,
            ),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating, // Set behavior to floating
            margin: EdgeInsets.only(bottom: 20), // Adjust the margin as needed
          ),
        );
      }
    }
  }



  // Future<void> _selectStartTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     builder: (context, childWidget) {
  //       return MediaQuery(
  //         data: MediaQuery.of(context).copyWith(
  //           alwaysUse24HourFormat: true,
  //         ),
  //         child: childWidget!,
  //       );
  //     },
  //   );

  //   if (picked != null) {
  //     // Convert the picked TimeOfDay to a DateTime object for comparison
  //     final pickedDateTime = DateTime(DateTime.now().year, DateTime.now().month,
  //         DateTime.now().day, picked.hour, picked.minute);
  //     final currentDateTime = DateTime.now();

  //     if (pickedDateTime.isAfter(currentDateTime)) {
  //       setState(() {
  //         _startTime = picked;
  //         _isTimeSelected =
  //             true; // Assuming _isTimeSelected is a boolean flag you've defined
  //       });
  //     } else {
  //       // Optionally, show a message to the user if the selected start time is not valid
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             'Start time must be after the current time.',
  //           style: TextStyle(color: AppColors.textLightblue),
  //             textAlign: TextAlign.center,
  //           ),
  //           backgroundColor: AppColors.errorColor,
  //           behavior: SnackBarBehavior.floating, // Set behavior to floating
  //           margin: EdgeInsets.only(bottom: 20), // Adjust the margin as needed
  //         ),
  //       );
  //     }
  //   }
  // }

Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: childWidget!,
        );
      },
    );

    if (picked != null) {
      // Convert the picked TimeOfDay to a DateTime object for comparison
      final pickedDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        picked.hour,
        picked.minute,
      );

      // Check if the picked start time is after the current time of the selected date
      if (pickedDateTime.isAfter(DateTime.now())) {
        setState(() {
          _startTime = picked;
          _isTimeSelected =
              true; // Assuming _isTimeSelected is a boolean flag you've defined
        });
      } else {
        // Optionally, show a message to the user if the selected start time is not valid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Start time must be after the current time of the selected date.',
              style: TextStyle(color: AppColors.textLightblue),
              textAlign: TextAlign.center,
            ),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating, // Set behavior to floating
            margin: EdgeInsets.only(bottom: 20), // Adjust the margin as needed
          ),
        );
      }
    }
  }


  double calculatePrice(DateTime? selectedStartDate, TimeOfDay startTime,
      DateTime? selectedEndDate, TimeOfDay endTime) {
    // Define the base rate per hour
    const double baseRatePerHour = 3.50;
    const double peakRatePerHour = 5.00;
    const double weekendRatePerHour = 4.00;
    const double discountRate = 0.9;

    // Check if startDate and endDate are not null
    if (selectedStartDate == null || selectedEndDate == null) {
      return 0.0;
    }

    // Convert TimeOfDay instances to DateTime instances
    DateTime startDateTime = DateTime(
      selectedStartDate.year,
      selectedStartDate.month,
      selectedStartDate.day,
      startTime.hour,
      startTime.minute,
    );
    DateTime endDateTime = DateTime(
      selectedEndDate.year,
      selectedEndDate.month,
      selectedEndDate.day,
      endTime.hour,
      endTime.minute,
    );

    // If the end time is before the start time, add one day to endDateTime
    if (endDateTime.isBefore(startDateTime)) {
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    // Calculate the duration of the booking in hours
    double durationInHours =
        endDateTime.difference(startDateTime).inMinutes / 60;

    // Determine if the startDateTime falls within peak hours
    bool isPeakTime =
        startDateTime.isAfter(peakStart) && startDateTime.isBefore(peakEnd);

    // Determine if the startDateTime is on a weekend
    bool isWeekend = startDateTime.weekday == DateTime.saturday ||
        startDateTime.weekday == DateTime.sunday;

    // Determine if the booking was made at least 24 hours in advance
    bool isAdvanceBooking =
        DateTime.now().difference(startDateTime).inHours >= 24;

    // Calculate the total price based on different rates and conditions
    double totalPrice;
    if (isPeakTime) {
      totalPrice = durationInHours * peakRatePerHour;
    } else if (isWeekend) {
      totalPrice = durationInHours * weekendRatePerHour;
    } else {
      totalPrice = durationInHours * baseRatePerHour;
    }

    // Apply discount for advance booking
    if (isAdvanceBooking) {
      totalPrice *= discountRate;
    }

    return totalPrice;
  }

  // double calculatePrice(
  //     DateTime? selectedDate, TimeOfDay startTime, TimeOfDay endTime) {
  //   if (selectedDate == null) {
  //     return 0.0; // Return 0 if selected date is null
  //   }
  //   // Convert TimeOfDay instances to DateTime instances
  //   DateTime startDateTime = DateTime(selectedDate.year, selectedDate.month,
  //       selectedDate.day, startTime.hour, startTime.minute);
  //   DateTime endDateTime = DateTime(selectedDate.year, selectedDate.month,
  //       selectedDate.day, endTime.hour, endTime.minute);

  //   // If the end time is before the start time, it means the booking spans across midnight
  //   // In this case, we add one day to the endDateTime to correctly calculate the duration
  //   if (endDateTime.isBefore(startDateTime)) {
  //     endDateTime = endDateTime.add(const Duration(days: 1));
  //   }

  //   // Calculate the difference between start and end time
  //   Duration duration = endDateTime.difference(startDateTime);

  //   // Calculate the price based on the duration
  //   // Replace this logic with your actual pricing calculation
  //   const double ratePerHour = 3.50; // Example rate per hour
  //   double totalPrice = (duration.inMinutes / 60) * ratePerHour;

  //   return totalPrice;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text('Book Slot Details'),
        ),
        body: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.greyDark,
                              offset: Offset(0, 2),
                              blurRadius: 2)
                        ],
                        color: AppColors.textLightblue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TextButton(
                                onPressed: () => _selectDate(context),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: _startDate == null
                                            ? 'Select Start Date'
                                            : 'Selected Start Date:\n',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryLight),
                                      ),
                                      if (_startDate != null)
                                        TextSpan(
                                          text: _startDate!
                                              .toString()
                                              .substring(0, 10),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.secondaryLight),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                onPressed: () => _selectStartTime(context),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: _isTimeSelected
                                            ? 'Time Selected: \n'
                                            : 'Start Time',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryLight),
                                      ),
                                      if (_isTimeSelected)
                                        TextSpan(
                                          text:
                                              '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.secondaryLight),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.greyDark,
                              offset: Offset(0, 2),
                              blurRadius: 2)
                        ],
                        color: AppColors.textLightblue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Column(children: [
                              TextButton(
                                onPressed: () => _selectEndDate(context),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: _endDate == null
                                            ? 'Select End Date'
                                            : 'Selected End Date:\n',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryLight),
                                      ),
                                      if (_endDate != null)
                                        TextSpan(
                                          text: _endDate!
                                              .toString()
                                              .substring(0, 10),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.secondaryLight),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              // const Text('End Hour'),
                              const SizedBox(
                                height: 10,
                              ),

                              TextButton(
                                onPressed: () => _selectEndTime(context),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: _isEndTimeSelected
                                            ? 'Time Selected: \n'
                                            : 'Select End Time',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryLight),
                                      ),
                                      if (_isEndTimeSelected)
                                        TextSpan(
                                          text:
                                              '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.secondaryLight),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ])
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        const Text(
                          'Amount:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textDark),
                        ),
                        const SizedBox(width: 10),
                        (_startDate != null &&
                                _endDate != null &&
                                _isTimeSelected &&
                                _isEndTimeSelected)
                            ? Text(
                                '\$${calculatePrice(_startDate, _startTime, _endDate, _endTime).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryLight,
                                ),
                              )
                            : const Text(
                                'Select date and time',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                              ),
                      ],
                    ),
                  ),
                  const Center(child: SizedBox(height: 20)),
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: PrimaryElevatedButton(
                      text: 'Book',
                      onPressed: () {
                        // Add your logic to book the slot
                        if (_startDate == null ||
                            _endDate == null ||
                            !_isTimeSelected ||
                            !_isEndTimeSelected) {
                          // If any date or time is not selected, show a SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.errorColor,
                              content: Center(
                                child: Text(
                                  'Select both a start and end date and time.',
                                  style:
                                      TextStyle(color: AppColors.textLightblue),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // If both a start and end date/time have been selected, proceed with booking
                          final startTime = DateTime(
                            _startDate!.year,
                            _startDate!.month,
                            _startDate!.day,
                            _startTime.hour,
                            _startTime.minute,
                          );

                          final endTime = DateTime(
                            _endDate!.year,
                            _endDate!.month,
                            _endDate!.day,
                            _endTime.hour,
                            _endTime.minute,
                          );
                          // Perform slot booking action
                          bookSlot(startTime, endTime, widget.slotId);
                        }
                      },
                    ),
                  ),
                ]),
          ),
        ));
  }

  void bookSlot(DateTime startTime, DateTime endTime, slotId) async {
    // Show progress indicator while checking slot availability
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checking Slot Availability...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(), // Show progress indicator
              SizedBox(height: 20),
              Text('Please wait...'),
            ],
          ),
        );
      },
    );

    try {
      // Check if the slot is available
      bool isAvailable = await isSlotAvailable(startTime, endTime, slotId);

      if (isAvailable) {
        // If the slot is available, proceed with booking
        // Convert DateTime objects to Firestore Timestamps
        Timestamp startTimeStamp = Timestamp.fromDate(startTime);
        Timestamp endTimeStamp = Timestamp.fromDate(endTime);

        // Define the data to be saved in Firestore
        Map<String, dynamic> bookingData = {
          'startTime': startTimeStamp,
          'endTime': endTimeStamp,
          'space_id': slotId,
          'status': 'pending', // Initial status of the booking
          'createdAt': FieldValue.serverTimestamp(), // Booking creation time
        };

        // Add the booking data to Firestore
        await FirebaseFirestore.instance
            .collection('bookings')
            .add(bookingData);

        // Booking saved successfully
        Navigator.pop(context); // Close the progress dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Booking successful.',
                style: TextStyle(color: AppColors.textLightorange),
              ),
            ),
            backgroundColor: AppColors.primaryColor,
            behavior: SnackBarBehavior.floating, // Set behavior to floating
            margin: EdgeInsets.only(bottom: 20), // Adjust the margin as needed
          ),
        );
        addUserActivity('You have successfully booked a slot');
      } else {
        // If the slot is not available, close the progress dialog and show an error message
        Navigator.pop(context); // Close the progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'The slot is not available for the selected time.',
                style: TextStyle(color: AppColors.textLightblue),
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating, // Set behavior to floating
            margin: EdgeInsets.only(bottom: 20), // Adjust the margin as needed
          ),
        );
      }
    } catch (error) {
      // Error occurred while checking slot availability or saving booking
      Navigator.pop(context); // Close the progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'You need to be signed in to book a slot',
              style: TextStyle(color: AppColors.textLightblue),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating, // Set behavior to floating
          margin: EdgeInsets.only(bottom: 20), // Adjust the margin as needed
        ),
      );
      //print(error);
    }
  }

  Future<bool> isSlotAvailable(
      DateTime startTime, DateTime endTime, String slotId) async {
    // Convert DateTime objects to Firestore Timestamps
    //Timestamp startTimeStamp = Timestamp.fromDate(startTime);
    //Timestamp endTimeStamp = Timestamp.fromDate(endTime);

    // Query Firestore for existing bookings that overlap with the requested time slot
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('space_id', isEqualTo: slotId)
        .get();

    // Check if any existing bookings overlap with the requested time slot
    bool isOverlapping = querySnapshot.docs.any((doc) {
      Timestamp existingStartTime = doc['startTime'];
      Timestamp existingEndTime = doc['endTime'];

      // Convert Timestamps to DateTime objects for comparison
      DateTime existingStartDateTime = existingStartTime.toDate();
      DateTime existingEndDateTime = existingEndTime.toDate();
      DateTime requestedStartDateTime = startTime;
      DateTime requestedEndDateTime = endTime;

      // Check if the existing booking overlaps with the requested time slot
      return (requestedStartDateTime.isBefore(existingEndDateTime) &&
          requestedEndDateTime.isAfter(existingStartDateTime));
    });

    return !isOverlapping; // Return true if the slot is available, false otherwise
  }

Future<void> addUserActivity( String activityDetails) async {
    try {
      // Create a new document in the user_activity collection with an auto-generated ID
      await FirebaseFirestore.instance.collection('user_activity').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'activity_details': activityDetails,
        'bookingTime': DateTime.now(),
        // Add other fields as needed
      });

      print('User activity added successfully');
    } catch (e) {
      print('Error adding user activity: $e');
    }
  }


}
