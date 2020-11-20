import 'package:flutter/material.dart';
import 'package:flutter_app_project1/model/photo.dart';

class DetailPage extends StatelessWidget {
  final Photos photos;

  DetailPage(this.photos);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: photos.id,
            child: Image.network(
              photos.src.original,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                );
              },
            ),
          ),
          OutlineButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      )),
    );
  }
}
