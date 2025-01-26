import { onDocumentCreated } from "firebase-functions/v2/firestore"; // Use v2 for Firebase Functions
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";

// Initialize Firebase Admin
initializeApp();

// Export Firestore-triggered functions
export const sendOfferNotification = onDocumentCreated("offers/{offerId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) {
    console.error("No data associated with the event");
    return;
  }

  const offerData = snapshot.data();

  const payload = {
    notification: {
      title: "New Offer!",
      body: `Check out the new offer: ${offerData.title}`,
    },
    topic: "offers",
  };

  try {
    await getMessaging().send(payload);
    console.log("Notification sent successfully to 'offers' topic");
  } catch (error) {
    console.error("Error sending notification:", error);
  }
});

export const sendMessageNotification = onDocumentCreated("chat/{chatId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) {
    console.error("No data associated with the event");
    return;
  }

  const messageData = snapshot.data();
  const receiverId = messageData.receiverId;
  const senderName = messageData.senderName || "Someone";

  const userDoc = await getFirestore().collection("users").doc(receiverId).get();
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
    await getMessaging().send(payload);
    console.log("Notification sent successfully to user:", receiverId);
  } catch (error) {
    console.error("Error sending notification:", error);
  }
});