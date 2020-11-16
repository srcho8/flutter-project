import 'package:flutter/material.dart';
import 'package:flutter_app_confer_1/model/confer.dart';
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatefulWidget {
  Confer confer;

  Detail(this.confer);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future<void> _launched;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.confer.name}',
              style: TextStyle(fontSize: 30),
            ),
            Text('${widget.confer.location}'),
            Text('${widget.confer.start} - ${widget.confer.end}'),
            InkWell(
              child: InkWell(
                child: Text("Go to official Website",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
                onTap: () {
                  setState(() {
                    _launched = _launchInWebViewOrVC(widget.confer.link);
                  });
                },
              ),
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
