import {initializeApp, firestore, messaging} from "firebase-admin";
import {region} from "firebase-functions";
import * as getUserList from './getUserList';
import * as onUserSwiped from './onUserSwiped';
import * as onNewMessage from './onNewMessage';

initializeApp();
const euWest1 = region("europe-west1");
const db = firestore();
const msg = messaging();

exports.getUserList = euWest1.https.onCall(getUserList.handler(db));
exports.onUserSwiped = euWest1.firestore.document('swipes/{swipe}').onCreate(onUserSwiped.handler(db, msg));
exports.onNewMessage = euWest1.firestore.document('chats/{chat}/messages/{message}').onCreate(onNewMessage.handler(db, msg));
