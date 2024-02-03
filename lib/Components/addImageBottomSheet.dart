import 'package:flutter/material.dart';
import 'package:tomatoes/main.dart';

class AddImageBottomSheet {
  final Function onPhotosTap;
  final Function onCameraTap;

  AddImageBottomSheet({required this.onCameraTap, required this.onPhotosTap});

  void show(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color(0xFFFFE2DC),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: thisSize.height * .03),
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text(
                  'Photos from library',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  onPhotosTap();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text(
                  'Take photo',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  onCameraTap();
                },
              ),
            ],
          );
        });
  }
}
