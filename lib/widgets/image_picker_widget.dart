import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget(this.getProfilePicture, {super.key});

  final Function getProfilePicture;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? profile;

  void _takePhoto() async {
    var proXFile = await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (proXFile == null) {
      return;
    }
    var _profile = await proXFile.readAsBytes();
    setState(() {
      profile = _profile;
    });
    widget.getProfilePicture(profile);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        profile == null
            ? const CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 60,
                child: Icon(
                  Icons.person,
                  size: 80,
                ),
              )
            : CircleAvatar(
                backgroundImage: MemoryImage(profile!),
                radius: 60,
              ),
        Positioned(
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: _takePhoto,
            child: const Icon(
              Icons.add_a_photo,
              color: Colors.blue,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
