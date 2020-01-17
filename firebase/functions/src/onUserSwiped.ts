import {DocumentSnapshot} from "firebase-functions/lib/providers/firestore";
import {messaging} from "firebase-admin";
import {getUserTokens} from "./util";

export const handler = (
    firestore: FirebaseFirestore.Firestore,
    msg: messaging.Messaging,
) => async (snapshot: DocumentSnapshot) => {
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

    const swipedUserTokens = await getUserTokens(swipedUser, firestore);
    const swipedByTokens = await getUserTokens(swipedBy, firestore);

    const payload = (messageFrom: string, chatId?: string) => {
        return {
            notification: {
                title: "It's a match",
                body: "Someone swiped right on you!",
            },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                notificationType: 'match',
                lastSwipe: swipedBy,
                messageFrom: messageFrom,
                ...chatId ? {chatId: chatId} : {},
                createdAt: new Date().getTime().toString(),
            },
        }
    };

    const chats = firestore.collection('chats');
    const existingChats = await chats.where('users.' + swipedUser, '==', true)
        .where('users.' + swipedBy, '==', true).limit(1).get();

    if (!existingChats.empty) {
        const id = existingChats.docs[0].id;
        if (swipedUserTokens?.length)
            await msg.sendToDevice(swipedUserTokens, payload(swipedBy, id));
        if (swipedByTokens?.length)
            await msg.sendToDevice(swipedByTokens, payload(swipedUser, id));
        return;
    }
    const chatDoc = await chats.add({
        users: {[swipedUser]: true, [swipedBy]: true},
    });
    if (swipedUserTokens?.length)
        await msg.sendToDevice(swipedUserTokens, payload(swipedBy, chatDoc.id));
    if (swipedByTokens?.length)
        await msg.sendToDevice(swipedByTokens, payload(swipedUser, chatDoc.id));
};
