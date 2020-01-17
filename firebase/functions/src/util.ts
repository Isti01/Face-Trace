export const getUserTokens = async (user: string, firestore: FirebaseFirestore.Firestore): Promise<Array<string>> => {
    const tokenDocs = await firestore.collection('tokens')
        .where('user', '==', user).get();

    return tokenDocs.docs.map(doc => doc.id);
};


export const wasSwiped = async (
    uid: string,
    partner: string,
    swipes: FirebaseFirestore.CollectionReference,
    transaction: FirebaseFirestore.Transaction,
): Promise<boolean> => {
    const swipe = await transaction.get(swipes
        .where('swipedBy', '==', uid)
        .where('swipedUser', '==', partner)
        .limit(1));

    return !swipe.empty;
};

export const getFaceData = async (
    uid: string,
    faces: FirebaseFirestore.CollectionReference,
    swipes: FirebaseFirestore.CollectionReference,
): Promise<Array<number> | undefined> => {
    const query = await swipes
        .where('swipedBy', '==', uid)
        .orderBy('createdAt', "desc")
        .limit(1).get();
    if (query.empty) return undefined;

    const data = query.docs[0]?.data();

    if (!data) return undefined;
    const swipedUser = data['swipedUser'];

    if (!swipedUser) return undefined;

    const swipedFace = await faces.doc(swipedUser).get();

    const swipedFaceData = swipedFace.data();

    if (!swipedFace.exists || !swipedFaceData) return undefined;
    const faceData = swipedFaceData['faceData'];

    if (!faceData || !Array.isArray(faceData)) return undefined;

    return faceData;
};


export interface map<T> {
    [index: string]: T
}
