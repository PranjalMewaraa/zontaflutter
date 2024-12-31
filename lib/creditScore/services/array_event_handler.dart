// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../models/array_event.dart';

// class ArrayEventHandler {
//   ArrayEvent handleArrayEvent(JavaScriptMessage message) {
//     try {
//       final eventData = json.decode(message.message) as Map<String, dynamic>;
//       final event = ArrayEvent.fromJson(eventData);

//       debugPrint('Array Events: ${event.event}');
//       debugPrint('Metadata: ${event.metadata}');

//       if (event.event == 'logout') {
//         debugPrint('Logout triggered with metadata: ${event.metadata}');
//       }

//       return event;
//     } catch (e) {
//       debugPrint('Error parsing Array event: $e');
//       return ArrayEvent(
//         tagName: 'unknown',
//         event: 'error',
//         metadata: 'Failed to parse event: $e',
//       );
//     }
//   }
// }
