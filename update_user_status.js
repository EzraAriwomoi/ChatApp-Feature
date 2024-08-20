const admin = require('firebase-admin');
const serviceAccount = require('./ult-whatsapp-firebase-adminsdk-l42r8-58ffdaa80b.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://ult-whatsapp-default-rtdb.firebaseio.com'
});

const db = admin.firestore();

async function updateUserStatus(uid, isActive) {
  try {
    const userRef = db.collection('users').doc(uid);
    await userRef.update({ active: isActive });
    console.log(`User ${uid} status updated to ${isActive}`);
  } catch (error) {
    console.error('Error updating user status:', error);
  }
}

// Update the status of a specific user
updateUserStatus('uid', false); // Replace 'userId' with actual user ID and false with the desired status
