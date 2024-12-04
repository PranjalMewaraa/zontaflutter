// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';
// import './js_scripts.dart';
// import './form_fields.dart';

// class ArrayController {
//   WebViewController? controller;
//   bool isFirstPage = true;
//   final Function(bool) onLoadingChanged;
//   final Function(String) onError;
//   final VoidCallback onStateChanged;

//   ArrayController({
//     required this.onLoadingChanged,
//     required this.onError,
//     required this.onStateChanged,
//   });

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
//     await _setupJavaScriptChannel(controller);
//     await _setupNavigationDelegate(controller);
//   }

//   Future<void> _setupJavaScriptChannel(WebViewController controller) async {
//     await controller.addJavaScriptChannel(
//       'ArrayEvents',
//       onMessageReceived: _handleArrayEvent,
//     );
//   }

//   Future<void> _setupNavigationDelegate(WebViewController controller) async {
//     await controller.setNavigationDelegate(
//       NavigationDelegate(
//         onPageStarted: (String url) {
//           debugPrint('Page started loading: $url');
//         },
//         onPageFinished: (String url) {
//           onLoadingChanged(false);
//           _setupPage(controller);
//         },
//         onWebResourceError: (WebResourceError error) {
//           onError(error.description);
//         },
//       ),
//     );
//   }

//   void _handleArrayEvent(JavaScriptMessage message) {
//     try {
//       final eventData = json.decode(message.message) as Map<String, dynamic>;
//       debugPrint('Array Events: ${eventData['event']}');
//       _processEventData(eventData);
//     } catch (e) {
//       debugPrint('Error parsing Array event: $e');
//     }
//   }

//   void _processEventData(Map<String, dynamic> eventData) {
//     if (eventData['metadata'] != null) {
//       _handleMetadata(eventData['metadata']);
//     }

//     switch (eventData['event']) {
//       case 'signup':
//         // Handle signup event
//         break;
//       case 'nextButtonClicked':
//         isFirstPage = false;
//         onStateChanged();
//         _populateFormData();
//         break;
//     }
//   }

//   void _handleMetadata(Map<String, dynamic> metadata) {
//     debugPrint('Metadata: $metadata');
//     if (metadata['user-token'] != null) {
//       _loadCreditOverviewPage(metadata['user-token']);
//     }
//     if (metadata['error'] != null) {
//       onError(metadata['error'].toString());
//     }
//   }

//   Future<void> _loadHtmlFromAssets(WebViewController controller) async {
//     try {
//       final fileContent =
//           await rootBundle.loadString('assets/array_embed.html');
//       await controller.loadHtmlString(fileContent,
//           baseUrl: 'https://embed.array.io');
//     } catch (e) {
//       onError('Failed to load Array component: $e');
//     }
//   }

//   Future<void> _loadCreditOverviewPage(String userToken) async {
//     try {
//       String htmlContent = '''
//       <body>
//         <array-credit-overview
//           appKey="3F03D20E-5311-43D8-8A76-E4B5D77793BD"
//           userToken="$userToken"
//           apiUrl="https://sandbox.array.io"
//           sandbox="true"
//         ></array-credit-overview>
//       </body>
//       ''';

//       final Uri uri = Uri.dataFromString(
//         htmlContent,
//         mimeType: 'text/html',
//         encoding: Encoding.getByName('utf-8')!,
//       );

//       await controller?.loadRequest(Uri.parse(uri.toString()));
//     } catch (e) {
//       debugPrint('Error injecting credit overview HTML: $e');
//     }
//   }

//   Future<void> _setupPage(WebViewController controller) async {
//     await _setupNextButtonListener(controller);
//     await _populateFormData();
//   }

//   Future<void> _setupNextButtonListener(WebViewController controller) async {
//     try {
//       await controller.runJavaScript(JsScripts.nextButtonListener);
//     } catch (e) {
//       debugPrint('Error setting up next button listener: $e');
//     }
//   }

//   Future<void> _populateFormData() async {
//     try {
//       final fields = isFirstPage
//           ? FormFields.firstPageFields
//           : FormFields.secondPageFields;
//       await controller?.runJavaScript('''
//         console.clear();
//         ${JsScripts.generateFormPopulation(fields)}
//       ''');
//     } catch (e) {
//       debugPrint('Error injecting form data JavaScript: $e');
//     }
//   }

//   void dispose() {
//     controller = null;
//   }
// }
