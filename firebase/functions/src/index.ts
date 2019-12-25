import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import {CallableContext} from "firebase-functions/lib/providers/https";

admin.initializeApp();
const region = functions.region("europe-west1");
const firestore = admin.firestore();


exports.getUserList = region.https.onCall(async (data: any, context: CallableContext) => {
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

exports.onUserSwiped = region.firestore.document('swipes/{swipe}').onCreate(async (snapshot) => {
    const data = snapshot.data();
    if (!snapshot.exists || data === undefined) return;
    const swipedUser = data['swipedUser'];
    const swipedBy = data['swipedBy'];

    if (!swipedUser || !swipedBy) return;
    if (swipedBy === swipedUser) return;

    const query = await firestore.collection('swipes')
        .where('swipedBy', '==', swipedUser)
        .where('swipedUser', '==', swipedBy)
        .where('right', '==', true).limit(1).get();

    if (query.empty) return;

    const chats = firestore.collection('chats');
    const existingChats = await chats.where('users.' + swipedUser, '==', true)
        .where('users.' + swipedBy, '==', true).limit(1).get();

    if (!existingChats.empty) return;

    return chats.add({
        users: {[swipedUser]: true, [swipedBy]: true},
    });

});

