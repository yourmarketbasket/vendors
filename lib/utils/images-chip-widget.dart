import 'dart:io';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ImagesChipInputField extends StatefulWidget {
  final List<String> initialImages;
  final ValueChanged<List<File>> onImagesChanged;
  final String labelText;
  final Color chipColor;
  final Color deleteIconColor;
  final ValueGetter<List<String>>? getImages;
  late List<File> updatedImages = [];

  ImagesChipInputField({
    required this.initialImages,
    required this.onImagesChanged,
    required this.labelText,
    this.chipColor = Colors.blue,
    this.deleteIconColor = Colors.grey,
    this.getImages,
  });

  @override
  _ImagesChipInputFieldState createState() => _ImagesChipInputFieldState();
}

class _ImagesChipInputFieldState extends State<ImagesChipInputField> {
  final List<String> _images = [];

  late ScrollController _scrollController;
  final _cropController = CropController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _images.addAll(widget.initialImages);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _images.map((image) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              image: _getImageProvider(image),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _images.remove(image);
                                  // widget.onImagesChanged(_images);
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: widget.deleteIconColor,
                                radius: 10,
                                child: Icon(
                                  Icons.close,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: _uploadImages,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.camera_alt),
                Text(widget.labelText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return DecorationImage(
        image: NetworkImage(imagePath),
        fit: BoxFit.fill,
      );
    } else {
      return DecorationImage(
        image: FileImage(File(imagePath)),
        fit: BoxFit.fill,
      );
    }
  }

  Future<void> _uploadImages() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File file = File(image.path);
      Uint8List bytes = await file.readAsBytes();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            title: Text('Crop Product Image'),
            content: Container(
              height: 400,
              width: 400,
              child: Crop(
                controller: _cropController,
                aspectRatio: 4 / 3,
                image: bytes,
                onCropped: (croppedImage) {
                  _handleCroppedImage(croppedImage);
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _cropController.crop();
                  Navigator.of(context).pop();
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.crop),
                    Text('Crop'),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _handleCroppedImage(Uint8List croppedImage) {
    String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    File('$imageName').writeAsBytes(croppedImage).then((File savedImage) {
      setState(() {
        _images.add(savedImage.path);
        widget.updatedImages.add(savedImage);
        widget.onImagesChanged(widget.updatedImages);
      });
    }).catchError((error) {
      print('Error saving image: $error');
    });
  }

  List<File> getImages() {
    return widget.updatedImages;
  }
}
