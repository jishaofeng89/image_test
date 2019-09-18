import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as picker;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:image_test/aspect_ratio.dart';
import 'package:image_test/aspect_ratio_item.dart';
import 'package:image_test/flat_button.dart';

class HeaderEditor extends StatefulWidget {
  HeaderEditor({Key key}) : super(key: key);

  _HeaderEditorState createState() => _HeaderEditorState();
}

class _HeaderEditorState extends State<HeaderEditor> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  List<AspectRatioItem> _aspectRatios = List<AspectRatioItem>()
    ..add(AspectRatioItem(aspectRatioS: "custom", aspectRatio: null))
    ..add(AspectRatioItem(aspectRatioS: "original", aspectRatio: -1.0))
    ..add(AspectRatioItem(
        aspectRatioS: "1*1", aspectRatio: CropAspectRatios.ratio1_1))
    ..add(AspectRatioItem(
        aspectRatioS: "4*3", aspectRatio: CropAspectRatios.ratio4_3))
    ..add(AspectRatioItem(
        aspectRatioS: "3*4", aspectRatio: CropAspectRatios.ratio3_4))
    ..add(AspectRatioItem(
        aspectRatioS: "16*9", aspectRatio: CropAspectRatios.ratio16_9))
    ..add(AspectRatioItem(
        aspectRatioS: "9*16", aspectRatio: CropAspectRatios.ratio9_16));

  AspectRatioItem _aspectRatio;

  @override
  void initState() {
    super.initState();
    _aspectRatio = _aspectRatios.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的形象'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: _getImage,
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _save,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _fileImage != null
                ? ExtendedImage.file(
                    _fileImage,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    enableLoadState: true,
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (state) {
                      return EditorConfig(
                          maxScale: 8.0,
                          cropRectPadding: EdgeInsets.all(20.0),
                          hitTestSize: 20.0,
                          cropAspectRatio: _aspectRatio.aspectRatio);
                    },
                  )
                : ExtendedImage.network(
                    'https://photo.tuchong.com/4870004/f/298584322.jpg',
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (state) {
                      return EditorConfig(
                          maxScale: 8.0,
                          cropRectPadding: EdgeInsets.all(20.0),
                          hitTestSize: 20.0,
                          cropAspectRatio: _aspectRatio.aspectRatio);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        shape: CircularNotchedRectangle(),
        child: ButtonTheme(
          minWidth: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FlatButtonWithIcon(
                icon: Icon(Icons.crop),
                label: Text(
                  'Crop',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  _showBottom(context);
                },
              ),
              FlatButtonWithIcon(
                icon: Icon(Icons.flip),
                label: Text(
                  'Flip',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.flip();
                },
              ),
              FlatButtonWithIcon(
                icon: Icon(Icons.rotate_left),
                label: Text(
                  'Rotate Left',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.rotate(right: false);
                },
              ),
              FlatButtonWithIcon(
                icon: Icon(Icons.rotate_right),
                label: Text(
                  'Rotate Right',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.rotate(right: true);
                },
              ),
              FlatButtonWithIcon(
                icon: Icon(Icons.restore),
                label: Text(
                  "Reset",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showBottom(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 60.0,
            color: Colors.lightBlue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                var item = _aspectRatios[index];
                return GestureDetector(
                  child: AspectRatioWidget(
                    aspectRatio: item.aspectRatio,
                    aspectRatioS: item.aspectRatioS,
                    isSelected: item == _aspectRatio,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _aspectRatio = item;
                    });
                  },
                );
              },
              itemCount: _aspectRatios.length,
            ),
          );
        });
  }

  void _save() async {
    try {
      var cropRect = editorKey.currentState.getCropRect();
      ui.Image imageData = editorKey.currentState.image;

      var data = await imageData.toByteData(format: ui.ImageByteFormat.png);
      image.Image src = image.decodePng(data.buffer.asUint8List());

      if (editorKey.currentState.editAction.hasEditAction) {
        var editAction = editorKey.currentState.editAction;
        src = copyFlip(src, flipX: editAction.flipX, flipY: editAction.flipY);
        if (editAction.hasRotateAngle) {
          // 整除 var a = 5 ~/ 2; // a的结果为2
          double angle = (editAction.rotateAngle ~/ (pi / 2)) * 90.0;
          src = image.copyRotate(src, angle);
        }
      }

      var cropData = image.copyCrop(
          src,
          cropRect.left.toInt(),
          cropRect.top.toInt(),
          cropRect.width.toInt(),
          cropRect.height.toInt());

      var filePath =
          await ImagePickerSaver.saveFile(fileData: image.encodePng(cropData));
      Fluttertoast.showToast(msg: 'save image: $filePath');
    } catch (e) {
      Fluttertoast.showToast(msg: 'save failed: $e');
    }
  }

  File _fileImage;

  void _getImage() async {
    var image =
        await picker.ImagePicker.pickImage(source: picker.ImageSource.gallery);
    setState(() {
      _fileImage = image;
    });
  }
}

image.Image copyFlip(image.Image src,
    {bool flipX = false, bool flipY = false}) {
  if (!flipX && !flipY) return src;

  image.Image dst = image.Image(src.width, src.height,
      channels: src.channels, exif: src.exif, iccp: src.iccProfile);

  for (int yi = 0; yi < src.height; ++yi,) {
    for (int xi = 0; xi < src.width; ++xi,) {
      var sx = flipY ? src.width - 1 - xi : xi;
      var sy = flipX ? src.height - 1 - yi : yi;
      dst.setPixel(xi, yi, src.getPixel(sx, sy));
    }
  }

  return dst;
}
