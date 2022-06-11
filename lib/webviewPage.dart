import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatelessWidget {

  const WebviewPage({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("omu"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        body: WebView(
          initialUrl: 'https://timeline.google.com/maps/timeline?gl=JP&pli=1&rapt=AEjHL4M3I_zsz1f63dpKxyBdafkyh7gAdSbJ0c_TJyfgXoDuIhK8CIGVVDyXTne0HvOXebMoLM05f1XHe_KjTXB4bGfIeZSbiQ&pb',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
