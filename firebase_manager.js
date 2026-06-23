const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

// Initialize the Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Example: Function to check if we can read from your database
async function verifyAccess() {
    try {
        console.log("Attempting to connect to Firestore...");
        const testDoc = await db.collection('test_connection').doc('status').get();
        console.log("Connection successful!");

        // Example: Writing data without the CLI
        await db.collection('test_connection').doc('status').set({
            last_connected: new Date().toISOString()
        });
        console.log("Data successfully written to Firestore.");
    } catch (error) {
        console.error("Error connecting to Firebase:", error.message);
    }
}

verifyAccess();