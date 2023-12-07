import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? selectedImage;
  pickCameraImage() async {
    final cameraImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (cameraImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(cameraImage.path);
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  pickGalleryImage() async {
    final cameraImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (cameraImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(cameraImage.path);
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  removeImage() async {
    setState(() {
      selectedImage = null;
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: pickCameraImage,
                      child: const Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: pickGalleryImage,
                      child: const Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: removeImage,
                      child: const Text(
                        'remove',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Center(
        child: CircleAvatar(
          minRadius: 45,
          maxRadius: 45,
          foregroundImage: selectedImage != null
              ? FileImage(selectedImage!)
              : const AssetImage('assets/noperson.png') as ImageProvider,
        ),
      ),
    );
  }
}
