import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagram_flutter/model/models.dart';
import 'package:instagram_flutter/resources/getUserModel.dart';
import 'package:instagram_flutter/resources/storage_meth.dart';

class AuthMeth {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String> signUp({
    required String email,
    required String pass,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = '';
    try {
      if (email.isNotEmpty ||
          pass.isNotEmpty ||
          bio.isNotEmpty ||
          username.isNotEmpty) {
        ///register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);

        ///upload image
        String photoUrl = await StorageMeth().uploadToStorage(
            fileName: 'profilePics', file: file, isPost: false);

        ///Store to database
        MyUser myUser = MyUser(
            id: cred.user!.uid,
            username: username,
            email: email,
            bio: bio,
            picUrl: photoUrl,
            follower: [],
            following: []);

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(myUser.toJson());

        ///store to provider

        await GetUserModel().setUserModel();
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signIn({
    required String email,
    required String pass,
  }) async {
    String res = '';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      await GetUserModel().setUserModel();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
