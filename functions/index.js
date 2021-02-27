const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.onCreatePost = functions.firestore
.document("/posts/{userId}/userPosts/{postId}")
.onCreate(async (snapshot, context)=>{
    const userId = context.params.userId;
    const postId = context.params.postId;
    //create user posts ref
    const userPostsRef = admin
    .firestore()
    .collection("posts")
    .doc(userId)
    .collection("userPosts");
    //create users timeline ref
    const userTimelinePostsRef = admin
    .firestore()
    .collection("timeline");
    //get users posts
    const querySnapshot = await userPostsRef.get();
    //add each user posts to users timeline
    querySnapshot.forEach(doc => {
        if (doc.exists) {
            const postId = doc.id;
            const postData = doc.data();
            userTimelinePostsRef.doc(postId).set(postData);
        }
    })
});