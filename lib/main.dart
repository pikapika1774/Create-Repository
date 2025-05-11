import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = WebviewController();
  final _urlController = TextEditingController(text: 'https://www.google.com');
  bool _isWebViewReady = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    await _controller.initialize();
    await _controller.loadUrl(_urlController.text);
    setState(() {
      _isWebViewReady = true;
    });
  }

  void _navigateToUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      _controller.loadUrl(url.startsWith('http') ? url : 'https://$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Windows',
      home: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 40,
            child: TextField(
              controller: _urlController,
              onSubmitted: (_) => _navigateToUrl(),
              decoration: InputDecoration(
                hintText: 'Enter URL',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _controller.goBack(); // そのまま呼ぶ
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                _controller.goForward(); // そのまま呼ぶ
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _controller.reload();
              },
            ),
            IconButton(icon: const Icon(Icons.send), onPressed: _navigateToUrl),
          ],
        ),
        body:
            _isWebViewReady
                ? Webview(_controller)
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
