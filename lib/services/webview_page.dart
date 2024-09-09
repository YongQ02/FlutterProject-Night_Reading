import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String initialUrl;

  const WebViewPage({
    super.key,
    required this.initialUrl,
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (kDebugMode) {
              print('Page started loading: $url');
            }
          },
          onPageFinished: (String url) {
            if (kDebugMode) {
              print('Page finished loading: $url');
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (kDebugMode) {
              print('Web resource error occurred: ${error}');
            }
            // Optionally show an error message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load page: ${error.description}')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Online'),
        backgroundColor: Colors.black,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}