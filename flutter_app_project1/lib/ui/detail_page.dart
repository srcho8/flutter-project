import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/ui/memo_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flushbar/flushbar.dart';

class DetailPage extends StatelessWidget {
  final Photos photos;

  DetailPage(this.photos);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${photos.photographer}',
          style: GoogleFonts.indieFlower(
              fontSize: 26, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              photos.src.original,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: LinearProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Photos provided by Pexels'),
                  onPressed: () {
                    String url = 'https://www.pexels.com';
                    _launchInWebViewOrVC(url);
                  },
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        child: Text(
                          '닫기',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    OutlinedButton(
                        child: Text(
                          '메모',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.push(
                                  context, FadeRoute(page: MemoPage(photos)))
                              .then((value) {
                            if (value == 'saved') {
                              Flushbar(
                                title: "InsFire",
                                message: "저장 되었습니다.",
                                duration: Duration(seconds: 2),
                              )..show(context);
                            }
                          });
                        }),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
