// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../services/array_event_handler.dart';
// import '../services/html_loader.dart';
// import '../services/page_setup_service.dart';
// import './web_view_util.dart';

// class ArrayWebViewController {
//   WebViewController? controller;
//   final Function(bool) onLoadingStateChanged;
//   final Function(String) onError;
//   final Function(bool) onComponentVisibility;
//   final ArrayEventHandler _eventHandler;
//   final HtmlLoader _htmlLoader;
//   final PageSetupService _pageSetup;
//   int _retryCount = 0;
//   static const int maxRetries = 3;

//   ArrayWebViewController({
//     required this.onLoadingStateChanged,
//     required this.onError,
//     required this.onComponentVisibility,
//   })  : _eventHandler = ArrayEventHandler(),
//         _htmlLoader = HtmlLoader(),
//         _pageSetup = PageSetupService();

//   Future<void> initialize() async {
//     final controller = WebViewController();
//     await _configureController(controller);
//     this.controller = controller;
//     await _loadHtmlFromAssets(controller);
//   }

//   Future<void> _configureController(WebViewController controller) async {
//     await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
//     await controller.setBackgroundColor(Colors.white);
//     await controller.enableZoom(false);

//     await controller.addJavaScriptChannel(
//       'ArrayEvents',
//       onMessageReceived: (message) => _handleArrayEvent(message),
//     );

//     await controller.setNavigationDelegate(
//       NavigationDelegate(
//         onPageStarted: (String url) {
//           debugPrint('Page started loading: $url');
//           onLoadingStateChanged(true);
//         },
//         onPageFinished: (String url) async {
//           await _onPageFinished(controller);
//         },
//         onWebResourceError: (WebResourceError error) {
//           _handleError(error);
//         },
//       ),
//     );
//   }

//   Future<void> _onPageFinished(WebViewController controller) async {
//     try {
//       await _pageSetup.setupPage(controller);
//       await _checkComponentVisibility(controller);
//       onLoadingStateChanged(false);
//     } catch (e) {
//       if (_retryCount < maxRetries) {
//         _retryCount++;
//         debugPrint('Retrying setup (attempt $_retryCount of $maxRetries)...');
//         await Future.delayed(const Duration(seconds: 1));
//         await _onPageFinished(controller);
//       } else {
//         onError(
//             'Failed to initialize Array component after $maxRetries attempts');
//       }
//     }
//   }

//   Future<void> _checkComponentVisibility(WebViewController controller) async {
//     const script = '''
//       const component = document.querySelector('array-credit-overview');
//       component !== null && component.shadowRoot !== null;
//     ''';
//     final result = await controller.runJavaScriptReturningResult(script);
//     onComponentVisibility(result == 'true');
//   }

//   void _handleArrayEvent(JavaScriptMessage message) {
//     final event = _eventHandler.handleArrayEvent(message);
//     if (event.event == 'component-visible-in-viewport') {
//       onComponentVisibility(true);
//     } else if (event.event == 'error') {
//       onError(event.metadata ?? 'Unknown error occurred');
//     }
//   }

//   void _handleError(WebResourceError error) {
//     final errorMessage = WebViewUtils.getErrorMessage(error);
//     onError(errorMessage);
//   }

//   Future<void> _loadHtmlFromAssets(WebViewController controller) async {
//     try {
//       await _htmlLoader.loadHtml(controller);
//     } catch (e) {
//       onError('Failed to load Array component: $e');
//     }
//   }

//   void dispose() {
//     controller?.clearCache();
//     controller = null;
//   }
// }
