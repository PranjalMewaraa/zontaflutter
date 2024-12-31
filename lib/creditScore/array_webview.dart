import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:zonta/screens/dashboard/dashboard_screen.dart';
import 'dart:convert';
import './form_fields.dart';
import './js_scripts.dart';

class ArrayWebView extends StatefulWidget {
  const ArrayWebView({super.key});

  @override
  State<ArrayWebView> createState() => _ArrayWebViewState();
}

class _ArrayWebViewState extends State<ArrayWebView> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _error;
  bool _isFirstPage = true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    final controller = WebViewController();

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setBackgroundColor(Colors.white);
    await controller.enableZoom(false);

    await controller.addJavaScriptChannel(
      'ArrayEvents',
      onMessageReceived: (JavaScriptMessage message) {
        _handleArrayEvent(message);
      },
    );

    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          debugPrint('Page started loading: $url');
        },
        onPageFinished: (String url) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            _setupPage(controller);
          }
        },
        onWebResourceError: (WebResourceError error) {
          _handleError(error.description);
        },
      ),
    );

    if (mounted) {
      setState(() {
        _controller = controller;
      });
    }

    await _loadHtmlFromAssets(controller);
  }

  Future<void> _handleArrayEvent(JavaScriptMessage message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final Map<String, dynamic> eventData =
          json.decode(message.message) as Map<String, dynamic>;
      debugPrint('Array Events: ${eventData['event']}');

      final metadata = eventData['metadata'];
      if (metadata != null) {
        debugPrint('Metadata: $metadata');
        final userToken = metadata['user-token'];
        if (userToken != null) {
          await prefs.setString('user_token', userToken); // Save as string
          _loadCreditOverviewPage(_controller!, userToken); // Pass the token
        }
      }

      if (eventData['event'] == 'signup') {
        if (mounted) {
          Navigator.pop(context);
        }
      } else if (eventData['event'] == 'nextButtonClicked') {
        setState(() {
          _isFirstPage = false;
        });
        _populateFormData(_controller!);
      } else if (metadata?['error'] != null) {
        _handleError(metadata['error'].toString());
      }
    } catch (e) {
      debugPrint('Error parsing Array event: $e');
    }
  }

  void _handleError(String errorMessage) {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _error = errorMessage;
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _error = null;
          });
        }
      });
    }
  }

  Future<void> _loadHtmlFromAssets(WebViewController controller) async {
    try {
      final fileContent =
          await rootBundle.loadString('assets/array_embed.html');
      await controller.loadHtmlString(fileContent,
          baseUrl: 'https://embed.array.io');
    } catch (e) {
      _handleError('Failed to load Array component: $e');
    }
  }

  Future<void> _loadCreditOverviewPage(
      WebViewController controller, String userToken) async {
    try {
      final String htmlContent = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script src="https://embed.array.io/cms/array-web-component.js?appKey=3F03D20E-5311-43D8-8A76-E4B5D77793BD"></script>
        <script
src="https://embed.array.io/cms/array-credit-overview.js?appKey=3F03D20E-5311-43D8-8A76-E4B5D77793BD"
></script>
          <style>
            body {
              margin: 0;
              padding: 0;
              height: 100vh;
              display: flex;
              justify-content: center;
              align-items: center;
               margin-top: 50px;
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
            userToken="$userToken"
            apiUrl="https://sandbox.array.io"
            sandbox="true"
              sandbox=true 
              defaultBureau= "tui"
              scoreGaugeStyle= "circular"
          ></array-credit-overview>
          <script>
            console.log('Credit Overview Initialized with userToken: $userToken');
          </script>
        </body>
      </html>
    ''';

      debugPrint('Loading credit overview HTML...');
      await controller.loadHtmlString(
        htmlContent,
        baseUrl: 'https://sandbox.array.io',
      );

      // Navigate to DashboardScreen after credit overview is loaded
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const DashboardScreen(), // Navigate to DashboardScreen
        ),
      );
    } catch (e) {
      debugPrint('Error injecting credit overview HTML: $e');
    }
  }

  Future<void> _setupPage(WebViewController controller) async {
    await _setupNextButtonListener(controller);
    await _populateFormData(controller);
  }

  Future<void> _setupNextButtonListener(WebViewController controller) async {
    try {
      await controller.runJavaScript(JsScripts.nextButtonListener);
    } catch (e) {
      debugPrint('Error setting up next button listener: $e');
    }
  }

  Future<void> _populateFormData(WebViewController controller) async {
    try {
      final fields = _isFirstPage
          ? FormFields.firstPageFields
          : FormFields.secondPageFields;
      await controller.runJavaScript('''
        console.clear();
        ${JsScripts.generateFormPopulation(fields)}
      ''');
    } catch (e) {
      debugPrint('Error injecting form data JavaScript: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_controller != null)
          WebViewWidget(
            controller: _controller!,
          ),
        if (_isLoading)
          const ColoredBox(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (_error != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.red.shade100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
