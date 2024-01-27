//this is the user class that will create and store all the informaiton of the user.
//this class we helps to use the user information to display it in the app.

import 'package:cloud_firestore/cloud_firestore.dart';

class userClass {
  userClass({
    required this.image,
    required this.firstName,
    required this.username,
    required this.lastName,
    required this.createAt,
    required this.isOnline,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.id,
    required this.recentlyView,
    required this.followers,
    required this.followings,
    required this.favoriteRecipe,
  });
  late String image;
  late String firstName;
  late String lastName;
  late String createAt;
  late String username;
  late String id;
  late bool isOnline;
  late String lastActive;
  late String pushToken;
  late String email;
  late List<String> recentlyView;
  late List<String> followers;
  late List<String> followings;
  late List<String> favoriteRecipe;

  //constructor that takes a Map<String, dynamic> as parameter.
  //convert json data into an instance of the class
  userClass.fromJson(Map<String, dynamic> json) {
    // if the value is not present, the ?? operator provides a default value
    //to avoid assigning the null to the property
    image = json['Image'] ?? '';
    firstName = json['First_name'] ?? '';
    lastName = json['Last_name'] ?? '';
    createAt = json['Create_At'] != null
        ? (json['Create_At'])
        : DateTime.now().millisecondsSinceEpoch.toString();
    id = json['Uid'] ?? '';
    username = json['Username'] ?? '';
    isOnline = json['isOnline'] ?? false;
    lastActive = DateTime.now().millisecondsSinceEpoch.toString();
    pushToken = json['pushToken'] ?? '';
    email = json['Email'] ?? '';
    recentlyView = (json['RecentlyView'] as List?)
            ?.map((item) => item as String)
            .toList() ??
        [];
    followers =
        (json['Followers'] as List?)?.map((item) => item as String).toList() ??
            [];
    followings =
        (json['Followings'] as List?)?.map((item) => item as String).toList() ??
            [];
    favoriteRecipe = (json['FavoriteRecipe'] as List?)
            ?.map((item) => item as String)
            .toList() ??
        [];
  }

  //this function is to assign the value from the userInput to the jSon file in firebase
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Image'] = image;
    data['First_name'] = firstName;
    data['Last_name'] = lastName;
    data['Create_At'] = createAt;
    data['Uid'] = id;
    data['Username'] = username;
    data['isOnline'] = isOnline;
    data['Last_active'] = lastActive;
    data['pushToken'] = pushToken;
    data['Email'] = email;
    data['RecentlyView'] = recentlyView;
    data['Followers'] = followers;
    data['Followings'] = followings;
    data['FavoriteRecipe'] = favoriteRecipe;

    return data;
  }
}
