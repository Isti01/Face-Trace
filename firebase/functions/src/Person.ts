import * as admin from "firebase-admin";
import Timestamp = admin.firestore.Timestamp;
import GeoPoint = admin.firestore.GeoPoint;

const interestIndecies: any = {
    'sports': 0,
    'music': 1,
    'reading': 2,
    'writing': 3,
    'arts': 4,
    'dancing': 5,
    'gardening': 6,
    'baking': 7,
    'movies': 8,
    'travelling': 9,
};

const now = new Date().getTime();

export class Person {
    uid: string;
    faceData: Array<number> | undefined;
    interests: Array<number> | undefined;
    value: number | undefined;
    birthDate: number | undefined;
    coordinates: Array<number> | undefined;


    constructor(
        faceData: Array<number> | undefined,
        interests: Array<string> | undefined,
        uid: string,
        birthDate: any,
        coordinates: Array<number> | undefined,
    ) {
        this.uid = uid;
        this.faceData = faceData;
        this.coordinates = coordinates;
        const interestNums = Array(10).fill(0);

        if (birthDate !== undefined && birthDate instanceof Timestamp) this.birthDate = birthDate.toMillis();

        if (interests && Array.isArray(interests)) {
            for (const interest of interests) interestNums[interestIndecies[interest]] = 1;
        }
        this.interests = interestNums;
    }

    evaluate(person: Person): number {
        if (!this.value) {
            const faceDist = Person.getDist(person.faceData, this.faceData);
            const interestDist = Person.getDist(person.interests, this.interests);
            const locationDist = Person.getDist(person.coordinates, this.coordinates);
            const birthDateValue = (this.birthDate || 0) / now;

            this.value = interestDist + faceDist + locationDist + birthDateValue;
        }

        return this.value;
    }

    static async parse(
        faceData: Array<number> | undefined,
        uid: string,
        data: FirebaseFirestore.DocumentData,
    ): Promise<Person> {
        const interests = Array.isArray(data['interests']) ? data['interests'] : [];
        const birthDate = data['birthDate'];

        const locationData = data['location'] || {};
        const location = locationData['geopoint'];
        const coordinates = location instanceof GeoPoint ? [location.latitude, location.longitude] : undefined;

        return new Person(faceData, interests, uid, birthDate, coordinates);
    }

    static getDist(vector: Array<number> | undefined, vector1: Array<number> | undefined): number {
        if (vector && vector1 && vector.length === vector1.length) {
            return Person.cosine(vector, vector1);
        }
        return 0;
    }

    static cosine(vector: Array<number>, vector1: Array<number>): number {
        let sum = 0;
        const length = vector.length;

        for (let i = 0; i < length; i++)
            sum += vector[i] * vector1[i];

        return sum / (Math.hypot(...vector) * Math.hypot(...vector1));
    }
}
