import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetailsScreen extends StatefulWidget {
  @override
  _PhotoDetailsScreenState createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  BuildContext _ctx;
  String GalleryId, ImageUrl, Title;
  String imageData;
  bool dataLoaded = false;

  int progress = 0;

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");
    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        GalleryId = arguments['GalleryId'];
        ImageUrl = arguments['ImageUrl'];
        Title = arguments['Title'];
           }
        });
    return Scaffold(
      appBar: AppBar(
        title: Text(Title),
        actions: [
          IconButton(
              icon: Icon(
                Icons.file_download,
                color: Colors.white,
              ),
              onPressed: () async {
                final status = await Permission.storage.request();
                if (status.isGranted) {
                  final externalDir = await getExternalStorageDirectory();
                  final id = await FlutterDownloader.enqueue(
                    url: RestDatasource.IMAGE_URL + ImageUrl,
                    savedDir: externalDir.path,
                    fileName: ImageUrl,
                    showNotification: true,
                    openFileFromNotification: true,
                    );
                  } else {
                  print("Permission deined");
                   }
              }),
        ],
      ),
      // add this body tag with container and photoview widget
      body: (dataLoaded)
          ? new Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              child: PhotoView(
                imageProvider: NetworkImage(
                    RestDatasource.IMAGE_URL + ImageUrl),
              ),
            ),
    );
  }
}
