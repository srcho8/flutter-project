import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_app_project1/ui/board_page.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';

class ScrollableExhibitionSheet extends StatefulWidget {
  @override
  _ScrollableExhibitionSheetState createState() =>
      _ScrollableExhibitionSheetState();
}

class _ScrollableExhibitionSheetState extends State<ScrollableExhibitionSheet> {
  double initialPercentage = 0.15;
  List<Event> events = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final streamAll = watch(streamFireStoreAll);

      return streamAll.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text(err.toString())),
          data: (snapshot) {
            events = snapshot.docs
                .map((e) => Event(
                      e.data()['miniImgUrl'],
                      e.data()['title'],
                      e.data()['username'],
                      DateFormat('yyyy-MM-dd hh:mm:ss')
                          .format(e.data()['datetime'].toDate())
                          .toString(),
                    ))
                .toList();

            return Positioned.fill(
              child: DraggableScrollableSheet(
                minChildSize: initialPercentage,
                initialChildSize: initialPercentage,
                builder: (context, scrollController) {
                  return AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, child) {
                      double percentage = initialPercentage;
                      if (scrollController.hasClients) {
                        percentage =
                            (scrollController.position.viewportDimension) /
                                (MediaQuery.of(context).size.height);
                      }
                      double scaledPercentage =
                          (percentage - initialPercentage) /
                              (1 - initialPercentage);
                      return Container(
                        padding: const EdgeInsets.only(left: 32),
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          //Color(0xFF162A49),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32)),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Opacity(
                              opacity: percentage == 1 ? 1 : 0,
                              child: ListView.builder(
                                padding: EdgeInsets.only(right: 32, top: 128),
                                controller: scrollController,
                                itemCount: snapshot.size,
                                itemBuilder: (context, index) {
                                  Event event = events[index];
                                  return MyEventItem(
                                    snapshot.docs[index],
                                    event: event,
                                    percentageCompleted: percentage,
                                  );
                                },
                              ),
                            ),
                            ...events.map((event) {
                              int index = events.indexOf(event);
                              int heightPerElement = 120;
                              double widthPerElement =
                                  40 + percentage * 80 + 8 * (1 - percentage);
                              double leftOffset = widthPerElement *
                                  (index > 4 ? index + 2 : index) *
                                  (1 - scaledPercentage);
                              return Positioned(
                                top: 44.0 +
                                    scaledPercentage * (128 - 44) +
                                    index * heightPerElement * scaledPercentage,
                                left: leftOffset,
                                right: 32 - leftOffset,
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Opacity(
                                    opacity: percentage == 1 ? 0 : 1,
                                    child: MyEventItem(
                                      snapshot.docs[index],
                                      event: event,
                                      percentageCompleted: percentage,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            SheetHeader(
                              fontSize: 14 + percentage * 8,
                              topMargin: 16 +
                                  percentage *
                                      MediaQuery.of(context).padding.top,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          });
    });
  }
}

class MyEventItem extends StatelessWidget {
  final Event event;
  final double percentageCompleted;
  final QueryDocumentSnapshot snapshot;

  const MyEventItem(this.snapshot,
      {Key key, this.event, this.percentageCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scale: 1 / 3 + 2 / 3 * percentageCompleted,
        child: InkWell(
          onTap: () {
            Navigator.push(context, FadeRoute(page: BoardPage(snapshot)));
          },
          child: SizedBox(
            height: 100,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16),
                    right: Radius.circular(16 * (1 - percentageCompleted)),
                  ),
                  child: ExtendedImage.network(
                    event.assetName,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    cache: true,
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: max(0, percentageCompleted * 2 - 1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(16)),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(8),
                      child: _buildContent(snapshot),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //List 뒤 내용 부분
  Widget _buildContent(QueryDocumentSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          event.title,
          style: TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Icon(Icons.favorite_rounded, size: 14,),
          SizedBox(width: 4,),
          Text('${snapshot.data()['likes'].length}')
        ],),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              event.contents,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.timer, color: Colors.grey.shade400, size: 16),
            Text(
              event.date,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            )
          ],
        )
      ],
    );
  }
}

class Event {
  final String assetName;
  final String title;
  final String contents;
  final String date;

  Event(this.assetName, this.title, this.contents, this.date);
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader(
      {Key key, @required this.fontSize, @required this.topMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 32,
      child: IgnorePointer(
        child: Container(
          padding: EdgeInsets.only(top: topMargin, bottom: 12),
          decoration: const BoxDecoration(color: Colors.blueGrey
              //Color(0xFF162A49),
              ),
          child: Text(
            'Online Exhibition',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
