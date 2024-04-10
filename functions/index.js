


const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();


exports.updateParkingStatus = functions.database.ref('/parking_slots/{sensorId}/status').onUpdate((change, context) => {
    const newValue = change.after.val(); // New value of the sensor status
    const sensorId = context.params.sensorId; // ID of the sensor
    
    // Query Firestore for the parking slot document with the matching space_id
    const parkingSlotRef = admin.firestore().collection('parkingSlots').where('space_id', '==', sensorId);
    
    // Update the Firestore document based on the sensor status
    return parkingSlotRef.get().then(querySnapshot => {
        if (!querySnapshot.empty) {
            const parkingSlotDoc = querySnapshot.docs[0];
            return parkingSlotDoc.ref.update({ status: newValue ? 'Occupied' : 'Available' })
                .then(() => {
                    console.log('Parking status updated successfully');
                })
                .catch(error => {
                    console.error('Error updating parking status:', error);
                });
        } else {
            console.log('No matching parking slot found for sensor ID:', sensorId);
        }
    });
});
