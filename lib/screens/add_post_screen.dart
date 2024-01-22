import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/firestore_meth.dart';

import '../model/models.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? postPic;
  final desController = TextEditingController();
  bool isLoading = false;
  String myUserPicUrl = MyUser.instance!.picUrl;

  void _sendPost() async {
    setState(() {
      isLoading = true;
    });
    try {
      String res =
          await FirestoreMeth().uploadPost(desController.text, postPic!);
      if (res.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Posted')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
    setState(() {
      postPic = null;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Sharing a Post?'),
        children: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _photoGallery();
              },
              child: const Text('gallery')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _photoCamera();
              },
              child: const Text('camera')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('cancel'))
        ],
      ),
    );
  }

  void _photoCamera() async {
    var proXFile = await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

    if (proXFile == null) {
      return;
    }
    var profile = await proXFile.readAsBytes();
    setState(() {
      postPic = profile;
    });
  }

  void _photoGallery() async {
    var proXFile = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);
    if (proXFile == null) {
      return;
    }
    var profile = await proXFile.readAsBytes();
    setState(() {
      postPic = profile;
    });
  }

  @override
  void dispose() {
    desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('...$myUserPicUrl');
    return postPic == null
        ? Center(
            child: IconButton(
              onPressed: _showDialog,
              icon: const Icon(
                Icons.add_box_outlined,
                color: Colors.white,
              ),
              iconSize: 255,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Post to'),
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      postPic = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () {
                      print('11111111');
                      _sendPost();
                      print('222222222');
                    },
                    child: const Text('Post'))
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                isLoading == true
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(myUserPicUrl!),
                        radius: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          controller: desController,
                          decoration: const InputDecoration(
                              hintText: 'Write a caption...',
                              border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(postPic!), fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
