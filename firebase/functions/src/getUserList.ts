import {Person} from "./Person";
import {getFaceData, map, wasSwiped} from "./util";
import {CallableContext} from "firebase-functions/lib/providers/https";

export const handler = (firestore: FirebaseFirestore.Firestore) => async (data: any, context: CallableContext) => {
    const uid = context?.auth?.uid;
    if (uid === undefined) return {message: "User is not authenticated", successful: false};
    const allUsers = firestore.collection("users");
    const faces = firestore.collection('faces');
    const swipes = firestore.collection('swipes');

    const currentUser = await allUsers.doc(uid).get();
    const userData = currentUser.data() || {};

    const faceData = await getFaceData(uid, faces, swipes);

    const interests = Array.isArray(userData['interests']) ? userData['interests'] : [];

    const person = new Person(faceData, interests, uid);
    const attractedTo = userData['attractedTo'] || [];
    let allUsersQuery: FirebaseFirestore.QuerySnapshot;

    if (Array.isArray(attractedTo)) {
        allUsersQuery = await allUsers.where('gender', 'in', attractedTo).get();
    } else {
        allUsersQuery = await allUsers.get();
    }

    const allPersons: map<Person> = {};

    const allUsersDocs = allUsersQuery.docs.filter(doc => doc.id !== uid);

    // here I do a lot of doc reading one by one.
    // I think doing it in one transaction might speed up the overall process
    await firestore.runTransaction(async (transaction) => {
            for (const doc of allUsersDocs) {
                const id = doc.id;

                if (await wasSwiped(uid, id, swipes, transaction)) continue;

                allPersons[id] = new Person(null, (doc.data() || {})['interests'], id);
            }
        }
    );
    const faceQuery = await faces.get();
    faceQuery.docs.filter(doc => doc.id !== uid).forEach((faceDataDoc) => {
        if (!allPersons[faceDataDoc.id]) return;

        const faceDataData = faceDataDoc.data() || {};

        const vector = faceDataData['faceData'];

        if (vector && Array.isArray(vector))
            allPersons[faceDataDoc.id].faceData = vector;
    });

    const allUserIds = allUsersDocs.map(doc => doc.id).filter(id => allPersons[id])
        .sort((s1, s2) => allPersons[s1].distance(person) - allPersons[s2].distance(person));

    return {
        successful: true,
        users: allUserIds,
        message: allUserIds.length > 0 ? "Request was successful" : "Could not find users"
    };
};

