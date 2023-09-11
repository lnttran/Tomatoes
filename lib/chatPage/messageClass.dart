//this is the messafe class that will create and store all the informaiton of the message.

import 'package:cloud_firestore/cloud_firestore.dart';

class messageClass {
  messageClass({
    required this.toID,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromID,
    required this.sent,
  });
  late final String toID;
  late final String msg;
  late final Type type;
  late final String fromID;
  late final String read;
  late final String sent;

  //constructor that takes a Map<String, dynamic> as parameter.
  //convert json data into an instance of the class
  messageClass.fromJson(Map<String, dynamic> json) {
    // if the value is not present, the ?? operator provides a default value
    //to avoid assigning the null to the property
    toID = json['toID'];
    msg = json['msg'];
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromID = json['fromID'];
    read = json['read'];
    sent = json['sent'];
  }

  //this function is to assign the value from the userInput to the jSon file in firebase
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toID'] = toID;
    data['msg'] = msg;
    data['type'] = type.name;
    data['fromID'] = fromID;
    data['read'] = read;
    data['sent'] = sent;

    return data;
  }
}

enum Type { text, image }
