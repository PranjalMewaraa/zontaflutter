// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PageSetupService {
//   Future<void> setupPage(WebViewController controller) async {
//     await _injectErrorHandler(controller);
//     await _setupComponentVisibilityCheck(controller);
//   }

//   Future<void> _injectErrorHandler(WebViewController controller) async {
//     const script = '''
//       window.onerror = function(message, source, lineno, colno, error) {
//         console.error('JavaScript Error:', message);
//         ArrayEvents.postMessage(JSON.stringify({
//           tagName: 'error-handler',
//           event: 'error',
//           metadata: message
//         }));
//         return true;
//       };
//     ''';
//     await controller.runJavaScript(script);
//   }

//   Future<void> _setupComponentVisibilityCheck(
//       WebViewController controller) async {
//     const script = '''
//       const checkComponentVisibility = () => {
//         const component = document.querySelector('array-credit-overview');
//         if (component && component.shadowRoot) {
//           ArrayEvents.postMessage(JSON.stringify({
//             tagName: 'array-credit-overview',
//             event: 'component-visible-in-viewport',
//             metadata: null
//           }));
//         }
//       };
      
//       // Check immediately and after a short delay
//       checkComponentVisibility();
//       setTimeout(checkComponentVisibility, 1000);
      
//       // Set up mutation observer to detect component mounting
//       const observer = new MutationObserver(checkComponentVisibility);
//       observer.observe(document.body, {
//         childList: true,
//         subtree: true
//       });
//     ''';
//     await controller.runJavaScript(script);
//   }
// }
