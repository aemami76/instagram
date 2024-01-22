import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/model/models.dart';

class GetUserModel {
  var _currentUser = FirebaseAuth.instance.currentUser;
  var _uid = FirebaseAuth.instance.currentUser?.uid;
  setUserModel() async {
    if (_currentUser != null) {
      print("....... Started");
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();

      var data = snap.data() as Map<String, dynamic>;

      print("....... Snapfrom first class = ${snap.data()}");

      MyUser myUser = MyUser(
          id: data['id'],
          username: data['username'],
          email: data['email'],
          bio: data['bio'],
          picUrl: data['picUrl'],
          follower: data['follower'] as List<dynamic>,
          following: data['following'] as List<dynamic>);

      print("....... MyUser = ${myUser.picUrl}");
      MyUser.instance = myUser;
    }
  }
}
