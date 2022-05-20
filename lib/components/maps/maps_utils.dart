import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(String name) async {
    final googleMapUrl = 
    Uri.parse("https://www.google.com/maps/search/?api=1&query=$name");

    if (!await launchUrl(
      googleMapUrl,
      mode: LaunchMode.externalApplication
      )) throw 'Could not launch $googleMapUrl';
    
  }

  static Future<void> openReadMore(String url) async {
    final readMoreUrl = Uri.parse(url);

    if (!await launchUrl(
      readMoreUrl,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: WebViewConfiguration(
        enableJavaScript: true,
        enableDomStorage: true
      )
      )) throw 'Could not launch $readMoreUrl';
    
  }
}
