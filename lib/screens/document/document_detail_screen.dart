
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../../components/navBar.dart';
import '../../models/image.dart';
import '../../widgets/app_default.dart';

class DocumentDetail extends StatefulWidget {
  final ImageClass image;
  const DocumentDetail(this.image, {Key? key}) : super(key: key);

  @override
  _DocumentDetailState createState() => _DocumentDetailState();
}

class _DocumentDetailState extends State<DocumentDetail> {
  late ImageClass image;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  Future<void> downloadDocument(String url) async {
    setState(() {
      isDownloading = true;
    });

    try {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: '/storage/emulated/0/Documents',
        showNotification: true,
        openFileFromNotification: true,
      ).catchError((onError) {
        print(onError);
        setState(() {
          isDownloading = false;
        });
      });
      print(taskId);
    } catch (e) {
      print(e);
      setState(() {
        isDownloading = false;
      });
    }
  }

  Future<bool> checkPermission() async {
    if (await Permission.storage.request().isGranted) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        String path = "${dir.path}/documents";
        // use path here
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image.name ?? 'defaultTag',
      child: Scaffold(
        appBar: const ROROAppBar(),
        drawer: const AppDrawer(),
        bottomNavigationBar: const MyBottomNavBar(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Image.network(
                    image.url ?? '',
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 1.5,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                image.name ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            !isDownloading
                ? Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          if (image.url != null) {
                            await downloadDocument(image.url!);
                          }
                          setState(() {
                            isDownloading = false;
                          });
                        },
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child: Center(
                            child: Icon(
                              Icons.file_download,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Download to Device'),
                      const SizedBox(height: 8),
                    ],
                  )
                : const Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}