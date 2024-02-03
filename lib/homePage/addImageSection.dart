import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomatoes/Components/addImageBottomSheet.dart';
import 'package:tomatoes/main.dart';

class addImageSection extends StatefulWidget {
  const addImageSection({super.key});

  @override
  State<addImageSection> createState() => _addImageSectionState();
  String? getPostImage() {
    return _addImageSectionState.postImage;
  }
}

class _addImageSectionState extends State<addImageSection> {
  final ImagePicker picker = ImagePicker();
  static String? postImage;

  Future pickImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print('Image Path : ${image.path}');
        setState(() {
          postImage = image.path;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print('Image picking error: $e');
    }
  }

  Future takeImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        print('Image Path : ${image.path}');
        setState(() {
          postImage = image.path;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print('Image picking error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return postImage != null
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    12.0), // Set your desired border radius
                child: Image.file(
                  File(postImage!), // Assuming postImage is a non-null String
                  width: thisSize.width,
                  height: thisSize.width,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: thisSize.width *
                    0.02, // Adjust this value based on the desired top margin
                right: thisSize.width *
                    0.02, // Adjust this value based on the desired right margin
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      postImage = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 251, 238, 235),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          )
        : DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            padding: const EdgeInsets.all(10),
            color: const Color.fromARGB(187, 108, 108, 108),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: GestureDetector(
                onTap: () => AddImageBottomSheet(
                        onCameraTap: takeImage, onPhotosTap: pickImage)
                    .show(context),
                child: Container(
                  height: thisSize.width,
                  width: thisSize.width,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 251, 238, 235)),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center items vertically
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.photo_library_rounded,
                        color: Colors.grey,
                        size: 30,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Add photos',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
