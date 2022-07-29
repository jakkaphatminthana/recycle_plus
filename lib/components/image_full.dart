import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class ImageFullScreen extends StatelessWidget {
  ImageFullScreen({
    Key? key,
    this.imageFile,
    this.imageNetwork,
    this.imageAsset,
  }) : super(key: key);

  File? imageFile;
  String? imageNetwork;
  String? imageAsset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Hero(
              tag: 'imageHero',
              child: (imageFile != null)
                  ? Image.file(imageFile!)
                  : (imageAsset != null)
                      ? Image.asset(imageAsset!)
                      : (imageNetwork != null)
                          ? Image.network(imageNetwork!)
                          : Text("Something Wrong", style: Roboto18_B_black),
            ),
          ),
        ),
      ),
    );
  }
}
