import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/Components/userClass.dart';
import 'package:tomatoes/chatPage/messageClass.dart';
import 'package:tomatoes/invertory/ingredientsClass.dart';

class APIs {
  // return current user
  static User? get currentUser => FirebaseAuth.instance.currentUser!;
  static final userCollection = FirebaseFirestore.instance.collection('Users');

  //for storing self information
  static userClass? me;

  static Future<userClass?> initializeMe() async {
    userClass? me;
    if (currentUser != null) {
      try {
        final DocumentSnapshot documentSnapshot =
            await userCollection.doc(currentUser!.uid).get();

        if (documentSnapshot.exists) {
          final userData = documentSnapshot.data() as Map<String, dynamic>;
          me = userClass.fromJson(userData);
        } else {
          print("User not found in Firestore");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
    return me;
    //       .then((QuerySnapshot querySnapshot) {
    //     if (querySnapshot.docs.isNotEmpty) {
    //       final userData = querySnapshot.docs[0].data() as Map<String, dynamic>;

    //       // Initialize the userClass object with retrieved data
    //       me = userClass(
    //         id: currentUser!.uid,
    //         firstName: userData['First_name'],
    //         lastName: userData['Last_name'],
    //         username: userData['Username'],
    //         email: currentUser!.email.toString(),
    //         image: currentUser!.photoURL.toString(),
    //         createAt: userData['Create_At'],
    //         isOnline: userData['isOnline'],
    //         lastActive: userData['Last_active'],
    //         pushToken: userData['pushToken'],
    //         followers: userData['Followers'],
    //         followings: userData['Followings'],
    //         recentlyView: userData['RecentlyView'],
    //       );

    //       // Now, you have the 'me' object initialized with the current user's information
    //       // print(
    //       //     'User Info: ${me!.firstName} ${me!.lastName}, Email: ${me!.email}');

    //       return me;
    //     }
    //   }).catchError((error) {
    //     print('Error retrieving user data: $error');
    //   });
    // }
    // return me;
  }

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_images/${currentUser!.uid}.$ext');

    print(file);
    try {
      //uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'images/$ext'))
          .then((e) {
        print('Data transfered: ${e.bytesTransferred / 1000} kb');
      });
      print("Success");
    } catch (e) {
      print("Upload failed");
    }

    // print("Done uploading");

    userClass? me = await initializeMe();

    if (me != null) {
      //update image in firestore database
      me.image = await ref.getDownloadURL();
      currentUser!.updatePhotoURL(me.image);

      if (currentUser != null && currentUser!.photoURL != null) {
        // Evict the image from cache
        await CachedNetworkImage.evictFromCache(currentUser!.photoURL!);
      }

      await userCollection.doc(currentUser!.uid).update({'Image': me.image});
    }
  }

  static Future<String> uploadPostPicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    //storage file ref with path
    final ref = storage
        .ref()
        .child('post_images/${currentUser!.uid}_${DateTime.now()}.$ext');

    print(file);
    try {
      //uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'images/$ext'))
          .then((e) {
        print('Data transfered: ${e.bytesTransferred / 1000} kb');
      });
      print("Success");
    } catch (e) {
      print("Upload failed");
    }

    return await ref.getDownloadURL();
  }

  static String getConversationID(String id) =>
      currentUser!.uid.hashCode <= id.hashCode
          ? '${currentUser!.uid}_$id'
          : '${id}_${currentUser!.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      userClass user) {
    return FirebaseFirestore.instance
        .collection('chat/${getConversationID(user.id)}/messages')
        .snapshots();
  }

  //chat(collection) -> conversation_id (doc) -> messages (collection) -> message(doc)

  //for sending message
  static Future<void> sendMessage(
      userClass chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    // Convert the current time to a Firestore Timestamp
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final messageClass message = messageClass(
        toID: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromID: currentUser!.uid,
        sent: time);

    final ref = FirebaseFirestore.instance
        .collection('chat/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  /// This function updates the time of read status
  static Future<void> updateMessageReadStatus(messageClass message) async {
    FirebaseFirestore.instance
        .collection('chat/${getConversationID(message.fromID)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  /// This funciton get the only last message from the message collection.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      userClass user) {
    return FirebaseFirestore.instance
        .collection('chat/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(userClass chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    print(file);
    try {
      //uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'images/$ext'))
          .then((p0) {
        print('Data transfered: ${p0.bytesTransferred / 1000} kb');
      });
      print("Success");
    } catch (e) {
      print("Upload failed");
    }

    print("Done uploading");

    userClass? me = await initializeMe();

    if (me != null) {
      //update image in firestore databases
      final imageUrl = await ref.getDownloadURL();
      await sendMessage(chatUser, imageUrl, Type.image);
    }
  }

  static Future<void> uploadUserPost(Recipe recipe) async {
    // final userPostClass newPost = userPostClass(
    //   // recipe: recipe,
    //   timeCreated: DateTime.now().millisecondsSinceEpoch.toString(),
    // );

    final ref = userCollection.doc(currentUser!.uid).collection('User Posts');
    await ref.doc(recipe.id.toString()).set(recipe.toJson());
  }

  static void onRecipeCardClicked(String recipeId) async {
    // Get user data
    DocumentSnapshot userSnapshot =
        await userCollection.doc(currentUser!.uid).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    List<String> recentlyViewList =
        List<String>.from(userData['RecentlyView'] ?? []);

    if (recentlyViewList.contains(recipeId)) {
      // If it's in the list, remove it from its current position
      recentlyViewList.remove(recipeId);
    }

    recentlyViewList.insert(0, recipeId);

    if (recentlyViewList.length > 10) {
      recentlyViewList.removeLast();
    }
    await userCollection
        .doc(currentUser!.uid)
        .update({'RecentlyView': recentlyViewList});
  }

  static void addIngredient(IngredientClass ingredient) async {
    final ref = userCollection
        .doc(currentUser!.uid)
        .collection('Available Ingredients');
    await ref.doc(ingredient.name).set(ingredient.toJson());
  }

  static void deleteIngredient(String name) async {
    final ref = userCollection
        .doc(currentUser!.uid)
        .collection('Available Ingredients');

    await ref.doc(name).delete();
  }

  static String capitalizeFirstLetter(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
  }

  static Future<void> addCurrentUserFollowing(String userUID) async {
    DocumentReference userRef = userCollection.doc(currentUser!.uid);
    DocumentSnapshot userDoc = await userRef.get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    List<dynamic> following = (userData['Followings'] as List<dynamic>?) ?? [];
    if (!following.contains(userUID)) {
      following.add(userUID);
      await userRef.update({'Followings': following});
      print('Follow succeeded');
    }
  }

  static Future<void> removeCurrentUserFollowing(String userUID) async {
    DocumentReference userRef = userCollection.doc(currentUser!.uid);
    DocumentSnapshot userDoc = await userRef.get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    List<dynamic> following = (userData['Followings'] as List<dynamic>?) ?? [];
    if (following.contains(userUID)) {
      following.remove(userUID);
      await userRef.update({'Followings': following});
    }
  }
}
