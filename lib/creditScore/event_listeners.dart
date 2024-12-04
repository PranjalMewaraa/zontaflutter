// class EventListeners {
//   static String generateNextButtonListener() {
//     return '''
//     function setupNextButtonListener() {
//       window.setTimeout(() => {
//         try {
//           const shadowRoot = getShadowRoot();
//           if (!shadowRoot) return;

//           const nextButton = shadowRoot.querySelector('button[type="submit"]');
//           if (nextButton) {
//             nextButton.addEventListener('click', () => {
//               window.ArrayEvents?.postMessage?.(JSON.stringify({event: 'nextButtonClicked'}));
//             });
//             console.log('Next button listener attached successfully.');
//           } else {
//             console.warn('Next button not found.');
//           }
//         } catch (error) {
//           console.error('Error attaching next button listener:', error);
//         }
//       }, 200);
//     }
//     ''';
//   }

//   static String generateMutationObserver() {
//     return '''
//     function setupMutationObserver(callback) {
//       const shadowRoot = getShadowRoot();
//       if (!shadowRoot) return;

//       new MutationObserver(mutations => {
//         if (mutations.some(m => m.addedNodes.length > 0)) {
//           callback();
//         }
//       }).observe(shadowRoot, { 
//         childList: true, 
//         subtree: true 
//       });
//     }
//     ''';
//   }
// }
