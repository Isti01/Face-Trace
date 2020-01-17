import {messaging} from "firebase-admin";
import {getUserTokens} from "./util";
import {EventContext} from "firebase-functions";

export const handler = (
    firestore: FirebaseFirestore.Firestore,
    msg: messaging.Messaging,
) => async (snapshot: FirebaseFirestore.DocumentSnapshot, context: EventContext) => {
    const data = snapshot.data();
    if (data === undefined) return;

    const userToAlert = data['to'];
    const createdBy = data['createdBy'];
    if (userToAlert === undefined ||
        createdBy === undefined ||
        typeof createdBy !== "string" ||
        typeof userToAlert !== "string") return;

    const tokens = await getUserTokens(userToAlert, firestore);

    const type = data['type'];
    const payload: messaging.MessagingPayload = {
        notification: {
            title: "New Message",
            body: type === 'image' ? "Someone sent you an image!" : "You got a new text message!"
        },
        data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            notificationType: 'chat_message',
            messageFrom: createdBy,
            chatId: context.params.chat,
            createdAt: new Date().getTime().toString(),
        },
    };

    await msg.sendToDevice(tokens, payload);
};
