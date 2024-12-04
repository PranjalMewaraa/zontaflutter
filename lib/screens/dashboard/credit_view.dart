import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreditView extends StatefulWidget {
  const CreditView({Key? key}) : super(key: key);

  @override
  _CreditViewState createState() => _CreditViewState();
}

class _CreditViewState extends State<CreditView> {
  late final WebViewController _controller;
  String? userToken;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _loadUserToken();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
        ),
      );
  }

  Future<void> _loadUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('user_token');
    });

    if (userToken != null) {
      _loadHtmlContent();
    }
  }

  Future<void> _loadHtmlContent() async {
    final htmlContent = _buildHtmlContent(userToken!);
    await _controller.loadHtmlString(htmlContent,
        baseUrl: 'https://sandbox.array.io');
  }

  String _buildHtmlContent(String token) {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script src="https://embed.array.io/cms/array-web-component.js?appKey=3F03D20E-5311-43D8-8A76-E4B5D77793BD"></script>
          <script src="https://embed.array.io/cms/array-credit-overview.js?appKey=3F03D20E-5311-43D8-8A76-E4B5D77793BD"></script>
          <style>
            body {
              margin: 0;
              padding: 0;
              height: 100vh;
              display: flex;
              justify-content: center;
              align-items: center;
            }
            array-credit-overview {
              width: 100%;
              height: 100%;
            }
          </style>
        </head>
        <body>
          <array-credit-overview 
            appKey="3F03D20E-5311-43D8-8A76-E4B5D77793BD"
            userToken="$token"
            apiUrl="https://sandbox.array.io"
            sandbox="true"
            defaultBureau="tui"
            scoreGaugeStyle= "circular"
            >
           
          </array-credit-overview>
          <script>
            console.log('Credit Overview Initialized with userToken: $token');
          </script>
        </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Fixed height for the container
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: userToken == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
