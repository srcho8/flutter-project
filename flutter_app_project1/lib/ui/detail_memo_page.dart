import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:InsFire/faderoute.dart';
import 'package:InsFire/model/photo.dart';
import 'package:InsFire/ui/create_memo_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flushbar/flushbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_downloader/image_downloader.dart';

class DetailPage extends StatefulWidget {
  final Photos photos;

  DetailPage(this.photos);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  InterstitialAd myInterstitial;

  @override
  void initState() {
    super.initState();
    myInterstitial = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial.load();
        }
        print("InterstitialAd event is $event");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    myInterstitial?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.photos.photographer}',
          style: GoogleFonts.indieFlower(
              fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.file_download,
                color: Colors.amberAccent,
              ),
              onPressed: () async {
                myInterstitial.load();
                var status = await Permission.storage.status;
                if (status.isUndetermined) {
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();
                  print(statuses[Permission
                      .storage]); // it should print PermissionStatus.granted
                } else if (status.isGranted) {
                  return showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return ClassicGeneralDialogWidget(
                        titleText: '사진',
                        contentText: '고화질로 사진을 받으시겠습니까?',
                        onPositiveClick: () {
                          myInterstitial
                              .show(
                            anchorType: AnchorType.bottom,
                            anchorOffset: 0.0,
                            horizontalCenterOffset: 0.0,
                          )
                              .then((value) {
                            try {
                              // ImageDownloader.downloadImage(widget.photos.src.original)
                              //     .then((value) {
                              //   Flushbar(
                              //     title: "InsFire",
                              //     message: "저장했어요. 갤러리를 확인해주세요.",
                              //     duration: Duration(seconds: 1),
                              //   ).show(context);
                              // });
                              Navigator.of(context).pop();
                            } on PlatformException catch (error) {
                              print(error);
                            }
                          });
                        },
                        onNegativeClick: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    animationType: DialogTransitionType.size,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 300),
                  );
                }
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    child: Text(
                      '메모',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                              context, FadeRoute(page: MemoPage(widget.photos)))
                          .then((value) {
                        if (value == 'saved') {
                          Flushbar(
                            title: "InsFire",
                            message: "저장 되었습니다.",
                            duration: Duration(seconds: 1),
                          )..show(context);
                        }
                      });
                    }),
              ],
            ),
            Image.network(
              widget.photos.src.original,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    'Photos provided by Pexels',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  onPressed: () {
                    String url = 'https://www.pexels.com';
                    _launchInWebViewOrVC(url);
                  },
                ),
              ],
            ),
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
