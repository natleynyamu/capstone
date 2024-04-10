import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slot_seek/custom/app_colors.dart';
import 'package:slot_seek/app/book_slot.dart';
import 'package:slot_seek/custom/custom_widgets.dart';
import 'package:slot_seek/auth/not_signedin.dart';
import 'package:slot_seek/app/notifications.dart';
import 'package:slot_seek/profile/profile.dart';
import 'package:intl/intl.dart'; // Import the intl package

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            title: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textLightorange),
                  ),
                ),
                GestureDetector(
                  onTap: () {
            
                  },
                  child: const Icon(
                    Icons.search,
                    color: AppColors.textLightorange,
                  ),
                )
              ],
            ),
            backgroundColor: AppColors.primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
        body: const ParkingLot(),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: AppColors.primaryColor,
            ),
            child: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: BottomNavigationBar(
                backgroundColor: AppColors.primaryColor,
                currentIndex: 0,
                selectedItemColor: AppColors.secondaryColor,
                unselectedItemColor: AppColors.greyLight,
                onTap: (index) {
                  if (index == 0) {
                    // Navigate to profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                  if (index == 1) {
                    // Check if user is signed in
                    if (FirebaseAuth.instance.currentUser != null) {
                      // Navigate to notifications page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationsPage()),
                      );
                    } else {
                      // Redirect user to another page (e.g., Sign in page)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInRequiredPage()),
                      );
                    }
                  }
                  // Implement navigation logic based on index
                  if (index == 2) {
                    // Check if user is signed in
                    if (FirebaseAuth.instance.currentUser != null) {
                      // Navigate to profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()),
                      );
                    } else {
                      // Redirect user to another page (e.g., Sign in page)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInRequiredPage()),
                      );
                    }
                  }
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Notifications',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ParkingLot extends StatelessWidget {
  const ParkingLot({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Parking Slots').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Or any loading indicator
          }

          // Convert the QuerySnapshot into a list of ParkingSlots
          final List<ParkingSlot> parkingSlots =
              snapshot.data!.docs.map((DocumentSnapshot doc) {
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;
            return ParkingSlot(
                slotId: data['space_id'] ?? '',
                //isOccupied: data['isOccupied'] ?? false,
                status: data['status'],
                type: data['type']);
          }).toList();

          // Split the parkingSlots list into two halves
          int halfLength = parkingSlots.length ~/ 2;
          List<ParkingSlot> firstHalf = parkingSlots.sublist(0, halfLength);
          List<ParkingSlot> secondHalf = parkingSlots.sublist(halfLength);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Choose a Slot',
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
                          'Visualize vacant parking slots on this Lot. Tap on a slot to book a slot',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Display the first half of parking slots in the first column
                          Column(
                            children: [
                              for (var slot in firstHalf)
                                ParkingSpace(
                                  slot: slot,
                                  onTap: () {
                                    _showSlotDetailsDialog(context, slot);
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          // Display the second half of parking slots in the second column
                          Column(
                            children: [
                              for (var slot in secondHalf)
                                ParkingSpace(
                                  slot: slot,
                                  onTap: () {
                                    _showSlotDetailsDialog(context, slot);
                                  },
                                ),
                            ],
                          ),
                          //   // Stairs icon
                          // Image.asset('images/stairs.png')
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.arrow_upward,
                            color: AppColors.greyDark,
                            size: 24,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Entry',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          );
        });
  }
}

void _showSlotDetailsDialog(BuildContext context, ParkingSlot slot) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const RadialGradient(
            center: Alignment(0.30, 0.86),
            radius: 0.06,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Slot Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: CloseButton(
                  color: AppColors.primaryColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text('Slot:'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      slot.slotId,
                      style: TextStyle(
                        color: slot.status == 'Available'
                            ? AppColors.primaryLight
                            : AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('Type:'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      slot.type,
                      style: TextStyle(
                        color: slot.status == 'Available'
                            ? AppColors.primaryLight
                            : AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('Status:'),
                    const SizedBox(
                      width: 10,
                    ),
                    if (slot.status == 'Available')
                      FutureBuilder<Map<String, dynamic>>(
                        future: getNextBookingInfo(slot.slotId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // Handle the error state
                            return Text(
                              'Error: ${snapshot.error}',
                              style:
                                  const TextStyle(color: AppColors.errorColor),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!['hasBooking']) {
                            // Get current time
                            DateTime currentTime = DateTime.now();
                            DateTime bookingStartTime =
                                DateFormat('yyyy-MM-dd HH:mm').parse(
                                    snapshot.data!['nextBookingStartTime']);
                            DateTime bookingEndTime =
                                DateFormat('yyyy-MM-dd HH:mm').parse(
                                    snapshot.data!['nextBookingEndTime']);

                            // Check if current time is between booking start time and end time
                            if (currentTime.isAfter(bookingStartTime) &&
                                currentTime.isBefore(bookingEndTime)) {
                              return Text(
                                'Booked until: ${snapshot.data!['nextBookingEndTime']}',
                                style: const TextStyle(
                                  color: AppColors.secondaryColor,
                                ),
                              );
                            } else if (currentTime.isBefore(bookingStartTime)) {
                              return Text(
                                'Available until: ${snapshot.data!['nextBookingStartTime']}',
                                style: const TextStyle(
                                  color: AppColors.primaryLight,
                                ),
                              );
                            } else {
                              return const Text(
                                'Available',
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                ),
                              );
                            }
                          } else {
                            return const Text(
                              'Available',
                              style: TextStyle(
                                color: AppColors.primaryLight,
                              ),
                            );
                          }
                        },
                      )
                    else
                      Text(
                        slot.status == 'Occupied'
                            ? 'Occupied until: Unknown'
                            : slot.status,
                        style: const TextStyle(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                PrimaryElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookSlotPage(slotId: slot.slotId),
                      ),
                    );
                  },
                  text: 'Book Slot',
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<Map<String, dynamic>> getNextBookingInfo(String slotId) async {
  // Query Firestore for future bookings related to the slot
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('bookings')
      .where('space_id', isEqualTo: slotId)
      // .where('startTime', isGreaterThanOrEqualTo: Timestamp.now())
      .orderBy(
          'startTime') // Order by start time to get the earliest booking first
      .orderBy('endTime')
      .limit(1) // Limit to only one result, which will be the earliest booking
      .get();

  // Check if there is any booking
  if (querySnapshot.docs.isNotEmpty) {
    // Get the data of the earliest booking
    Map<String, dynamic> bookingData =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

    // Extract the start time from the booking data
    Timestamp startTimeStamp = bookingData['startTime'] as Timestamp;
    Timestamp endTimeStamp = bookingData['endTime'] as Timestamp;

    DateTime startTime = startTimeStamp.toDate();
    DateTime endTime = endTimeStamp.toDate();

    // Format the start time as a string (you can customize the format based on your requirement)
    String formattedStartTime =
        DateFormat('yyyy-MM-dd HH:mm').format(startTime);
    String formattedEndTime = DateFormat('yyyy-MM-dd HH:mm').format(endTime);

    return {
      'hasBooking': true,
      'nextBookingStartTime': formattedStartTime,
      'nextBookingEndTime': formattedEndTime,
    };
  } else {
    // If there are no future bookings, return null
    return {'hasBooking': false};
  }
}

class ParkingSpace extends StatelessWidget {
  final ParkingSlot slot;
  final VoidCallback onTap;

  const ParkingSpace({
    Key? key,
    required this.slot,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color slotColor = slot.status == 'Occupied'
        ? AppColors.greyLight
        : AppColors.textLightblue;
    Color textColor = slot.status == 'Occupied'
        ? AppColors.secondaryColor
        : AppColors.primaryColor;
    IconData iconData =
        slot.status == 'Occupied' ? Icons.lock : Icons.lock_open;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 70,
        decoration: BoxDecoration(
          color: slotColor,
          border: Border.all(
            color: AppColors.greyMedium,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      slot.slotId,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Icon(
                      iconData,
                      color: textColor,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  slot.status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ParkingSlot {
  // final String lotName;
  final String slotId;
  // final bool isOccupied;
  final String status;
  final String type;

  ParkingSlot({
    // required this.lotName,
    required this.slotId,
    // required this.isOccupied,
    required this.status,
    required this.type,
  });
}
