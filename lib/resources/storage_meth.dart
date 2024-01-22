import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMeth {
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> uploadToStorage(
      {required String fileName,
      required Uint8List file,
      required bool isPost}) async {
    Reference ref = _storage.ref(fileName).child(_auth.currentUser!.uid);

    if (isPost) {
      String uuid = const Uuid().v1();
      ref = ref.child(uuid);
    }

    await ref.putData(file);

    var url2 = await ref.getDownloadURL();

    return url2;
  }
}
