import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';

import '../../components/navBar.dart';
import '../../widgets/app_default.dart';

class ExtraInfo extends StatefulWidget {
  const ExtraInfo({Key? key}) : super(key: key);

  @override
  State<ExtraInfo> createState() => _ExtraInfoState();
}

class _ExtraInfoState extends State<ExtraInfo> {

  final String _errorImage =
      "https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg";
  final String _url1 =
      "https://www.healio.com/news/primary-care/20180420/how-to-use-food-as-medicine-to-prevent-reverse-chronic-diseases";
  final String _url2 =
      "https://www.heart.org/en/health-topics/consumer-healthcare/medication-information/medication-adherence-taking-your-meds-as-directed";
  final String _url3 =
      "https://www.cdc.gov/chronicdisease/about/prevent/index.htm";
  final String _url4 = "https://youtu.be/kWLCe4QrwPM";
  final String _url5 = "https://www.forbes.com/sites/williamhaseltine/2020/01/10/top-10-tips-for-caring-for-older-adults/?sh=46a95917a5ed";

  @override
  void initState() {
    super.initState();
    _getMetadata(_url5);
  }

  void _getMetadata(String url) async {
    bool isValid = _getUrlValid(url);
    if (isValid) {
      Metadata? metadata = await AnyLinkPreview.getMetadata(
        link: url,
        cache: const Duration(days: 7),
        proxyUrl: "https://cors-anywhere.herokuapp.com/", // Needed for web app
      );
     if (metadata != null) {
      debugPrint(metadata.title);
      debugPrint(metadata.desc);
    } else {
      debugPrint("No metadata found");
    }
    } else {
      debugPrint("URL is not valid");
    }
  }

  bool _getUrlValid(String url) {
    bool isUrlValid = AnyLinkPreview.isValidLink(
      url,
      protocols: ['http', 'https'],
      hostWhitelist: ['https://youtube.com/'],
      hostBlacklist: ['https://facebook.com/'],
    );
    return isUrlValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ROROAppBar(),
      drawer:const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnyLinkPreview(
              link: _url1,
              displayDirection: UIDirection.uiDirectionHorizontal,
              cache: const Duration(hours: 1),
              backgroundColor: Colors.grey[300],
              errorWidget: Container(
                color: Colors.grey[300],
                child: const Text('Oops!'),
              ),
              errorImage: _errorImage,
            ),
            const SizedBox(height: 25),
            AnyLinkPreview(
              link: _url2,
              displayDirection: UIDirection.uiDirectionHorizontal,
              showMultimedia: false,
              bodyMaxLines: 5,
              bodyTextOverflow: TextOverflow.ellipsis,
              titleStyle: const TextStyle(
                color: Colors.black,
                fontFamily: 'Mulish',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Mulish',),
            ),
            const SizedBox(height: 25),
            AnyLinkPreview(
              displayDirection: UIDirection.uiDirectionHorizontal,
              link: _url3,
              errorBody: 'Show my custom error body',
              errorTitle: 'Next one is youtube link, error title',
            ),
            const SizedBox(height: 25),
            AnyLinkPreview(link: _url4),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
