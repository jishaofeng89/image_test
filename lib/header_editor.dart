import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_test/aspect_ratio_item.dart';

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
    ..add(AspectRatioItem(aspectRatioS: "1*1", aspectRatio: CropAspectRatios.ratio1_1))
    ..add(AspectRatioItem(aspectRatioS: "4*3", aspectRatio: CropAspectRatios.ratio4_3))
    ..add(AspectRatioItem(aspectRatioS: "3*4", aspectRatio: CropAspectRatios.ratio3_4))
    ..add(AspectRatioItem(aspectRatioS: "16*9", aspectRatio: CropAspectRatios.ratio16_9))
    ..add(AspectRatioItem(aspectRatioS: "9*16", aspectRatio: CropAspectRatios.ratio9_16));

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
      ),
      body: Center(
        child: Text('老美了'),
      ),
    );
  }
}