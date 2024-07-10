const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

exports.addAdminRole = functions.https.onCall(async (data, context) => {
  // Check if the request is made by an authenticated admin
  if (context.auth.token.admin !== true) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'The function must be called by an authenticated admin.'
    );
  }

  const email = data.email;

  try {
    // Get user by email
    const user = await admin.auth().getUserByEmail(email);
    
    // Set custom user claims
    await admin.auth().setCustomUserClaims(user.uid, {
      admin: true,
    });

    return {
      message: `Success! ${email} has been made an admin.`
    };
  } catch (error) {
    return {
      error: error.message
    };
  }
});
