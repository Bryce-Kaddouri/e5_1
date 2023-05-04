import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final controller = MultiImagePickerController(
    maxImages: 10,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          MultiImagePickerView(
            onChange: (list) {
              debugPrint(list.toString());
            },
            controller: controller,
            padding: const EdgeInsets.all(10),
          ),
          const SizedBox(height: 32),
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () {
              final images = controller.images;
              // use these images
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(images.map((e) => e.name).toString())));
            },
          ),
        ],
      ),
    );
  }
}
