const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendOfferNotification = functions.firestore
  .document("offers/{offerId}")
  .onCreate(async (snapshot) => {
    const offerData = snapshot.data();

    const payload = {
      notification: {
        title: "New Offer!",
        body: `Check out the new offer: ${offerData.title}`,
      },
      topic: "offers",
    };

    try {
      await admin.messaging().send(payload);
      console.log("Notification sent successfully to 'offers' topic");
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });

exports.sendMessageNotification = functions.firestore
  .document("messages/{messageId}")
  .onCreate(async (snapshot) => {
    const messageData = snapshot.data();
    const receiverId = messageData.receiverId;
    const senderName = messageData.senderName || "Someone";

    const userDoc = await admin.firestore().collection("users").doc(receiverId).get();
    const userData = userDoc.data();
    const fcmToken = userData?.fcmToken;

    if (!fcmToken) {
      console.error("No FCM token found for receiver:", receiverId);
      return;
    }

    const payload = {
      notification: {
        title: "New Message",
        body: `${senderName} sent you a message: ${messageData.message}`,
      },
      token: fcmToken,
    };

    try {
      await admin.messaging().send(payload);
      console.log("Notification sent successfully to user:", receiverId);
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });
