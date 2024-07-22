const admin = require('firebase-admin');
const serviceAccount = require('./smart-retail-app-4b6a5-firebase-adminsdk-jbwte-085afc4182.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const uid = "StKoTb1pOFcA7dLmRclvcLe7u4B2";  // Replace with the actual UID of the admin user

admin.auth().setCustomUserClaims(uid, { admin: true })
  .then(() => {
    console.log("Custom claims set for admin user");
  })
  .catch(error => {
    console.log("Error setting custom claims:", error);
  });
