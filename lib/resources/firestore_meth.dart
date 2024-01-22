import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/model/models.dart';
import 'package:instagram_flutter/resources/storage_meth.dart';
import 'package:uuid/uuid.dart';

class FirestoreMeth {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> followUser(String id, String followId) async {
    try {
      var snap = await _firestore.collection('users').doc(id).get();
      List following = snap.data()!['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([id])
        });

        await _firestore.collection('users').doc(id).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([id])
        });

        await _firestore.collection('users').doc(id).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> uploadPost(
    String desc,
    Uint8List file,
  ) async {
    String res = 'Some error';
    String postUrl = await StorageMeth()
        .uploadToStorage(fileName: 'post', file: file, isPost: true);
    final myUser = MyUser.instance!;

    String postId = const Uuid().v1();
    MyPost myPost = MyPost(
        id: myUser.id,
        username: myUser.username,
        email: myUser.email,
        desc: desc,
        postId: postId,
        postUrl: postUrl,
        profileImage: myUser.picUrl,
        like: [],
        dateTime: DateTime.now());

    _firestore.collection('posts').doc(postId).set(myPost.toJson());
    res = '';

    try {} catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> uploadComment(String comment, String postId) async {
    final myUser = MyUser.instance!;
    String res = '';
    try {
      String uuid = const Uuid().v1();
      _firestore
          .collection('posts')
          .doc(postId)
          .collection('comment')
          .doc(uuid)
          .set({
        'comment': comment,
        'username': myUser.username,
        'picUrl': myUser.picUrl,
        'date': DateTime.now().toString()
      });
      res = '';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
