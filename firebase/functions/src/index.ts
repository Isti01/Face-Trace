import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import {CallableContext} from "firebase-functions/lib/providers/https";

admin.initializeApp();
const region = "europe-west1";
const firestore = admin.firestore();
exports.getUserList = functions.region(region).https.onCall(async (data: any, context: CallableContext) => {
    const uid = context?.auth?.uid;
    if (uid == null) return {message: "User is not authenticated", successful: false};

    const users = (await firestore.collection("users").listDocuments())
        .filter(value => value.id !== uid)
        .map(value => value.id);
    return {
        successful: true,
        users: users,
        message: users.length > 0 ? "Request was successful" : "Could not find users"
    };
});


