import 'dart:ui';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static String api_key = "AIzaSyAaATaZ1TE5aeCFY4SWx6p70KWWQVL5K1M";
  List<YT_API> results = [];
  YoutubeAPI yt = YoutubeAPI(api_key, maxResults: 6, type: "video");
  bool isLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
  }

  callApi() async {
    try {
      results = await yt.search("HD Music");
      print(results);
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Youtube API",
            style: TextStyle(color: Colors.black, fontFamily: "Poppins"),
          ),
          centerTitle: true,
          leading: Icon(
            FeatherIcons.youtube,
            color: Colors.red,
            size: 28,
          ),
        ),
        body: isLoaded
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      String url = results[index].url;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: (Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          index == 0
                              ? Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "TOP TRENDING",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins"),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.whatshot,
                                        color: Colors.red,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 40,
                                        color: index == 0
                                            ? Colors.red[50]
                                            : Color.fromRGBO(0, 0, 0, 0.09))
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(28),
                                        topRight: Radius.circular(28)),
                                    child: Image.network(
                                      results[index].thumbnail['medium']["url"],
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            results[index].channelTitle,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins"),
                                          ),
                                        ),
                                        index == 0
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.favorite_border,
                                                color: Colors.grey,
                                              )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        bottom: 15,
                                        top: 10),
                                    child: Text(
                                      results[index].duration,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins"),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    )),
                  );
                },
                itemCount: results.length,
              )
            : Center(
                child: SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    spinnerMode: true,
                    size: 40,
                  ),
                ),
              ),
      ),
    );
  }
}
