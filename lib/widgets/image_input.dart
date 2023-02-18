// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput({
    Key? key,
    required this.onSelectImage,
  }) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy(
      '${appDir.path}/$fileName)',
    );
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          height: 100,
          width: 180,
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Text("Nenhuma imagem!"),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: Icon(
              Icons.camera,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text(
              'Tirar Foto',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        )
      ],
    );
  }
}
