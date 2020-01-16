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

export class Person {
    uid: string;
    faceData: Array<number> | null;
    interests: Array<number> | null;
    difference: number | undefined;

    constructor(faceData: Array<number> | null, interests: Array<string> | null, uid: string) {
        this.uid = uid;
        this.faceData = faceData;
        const interestNums = Array(10).fill(0);

        if (interests && Array.isArray(interests)) {
            for (const interest of interests) interestNums[interestIndecies[interest]] = 1;
        }
        this.interests = interestNums;
    }

    distance(person: Person): number {
        if (!this.difference) {
            let faceDist = 0;
            if (person.faceData && this.faceData && person.faceData.length === this.faceData.length)
                faceDist = Person.cosine(person.faceData, this.faceData);

            let interestDist = 0;
            if (person.interests && this.interests && person.interests.length === this.interests.length) {
                interestDist = Person.cosine(person.interests, this.interests);
            }

            this.difference = (interestDist + faceDist) / 2;
        }

        return this.difference;
    }

    static cosine(vector: Array<number>, vector1: Array<number>): number {
        let sum = 0;
        const length = vector.length;

        for (let i = 0; i < length; i++)
            sum += vector[i] * vector1[i];

        return sum / (Math.hypot(...vector) * Math.hypot(...vector1));
    }
}
