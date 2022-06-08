import 'dart:io';

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

  static Future<void> storeRedirection() async {
    final playStore = 
    Uri.parse("https://play.google.com/store/apps?hl=fr&gl=US");
    final appStore = 
    Uri.parse("https://www.apple.com/fr/app-store/");

    if (Platform.isAndroid){
      if (!await launchUrl(
      playStore,
      mode: LaunchMode.externalApplication
      )) throw 'Could not launch $playStore';
    } else {
      if (!await launchUrl(
      appStore,
      mode: LaunchMode.externalApplication
      )) throw 'Could not launch $appStore';
    }
    
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

  static Future<void> launchEmail(
    String toEmail, String subject) async {
    final url = 
    Uri.parse("mailto:$toEmail?subject=${Uri.encodeFull(subject)}");

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication
      )) throw 'Could not launch $url';
    
  }
}
