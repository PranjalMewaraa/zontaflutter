class JsScripts {
  static const String nextButtonListener = '''
    window.setTimeout(() => {
      const enrollComponent = document.querySelector('array-account-enroll');
      if (enrollComponent && enrollComponent.shadowRoot) {
        const nextButton = enrollComponent.shadowRoot.querySelector('button[type="submit"]');
        if (nextButton) {
          nextButton.addEventListener('click', () => {
            window.ArrayEvents.postMessage(JSON.stringify({event: 'nextButtonClicked'}));
          });
        }
      }
    }, 200);
  ''';

  static String generateFormPopulation(Map<String, String> formFields) {
    final fieldsJson = _mapToJsObject(formFields);

    return '''
  function populateFormFields() {
    const enrollComponent = document.querySelector('array-account-enroll');
    if (!enrollComponent) {
      console.error('Enroll component not found');
      return;
    }

    const shadowRoot = enrollComponent.shadowRoot;
    if (!shadowRoot) {
      console.error('Shadow root not found');
      return;
    }

    const formFields = $fieldsJson;

    // Log available fields
    const inputs = shadowRoot.querySelectorAll('input, select, textarea');
    console.log('Available fields in shadow DOM:');
    inputs.forEach(input => console.log(`Field Name: \${input.name}, ID: \${input.id}`));

    Object.entries(formFields).forEach(([fieldName, value]) => {
      // Handle fields by both name and ID
      let input = shadowRoot.querySelector(`[name="\${fieldName}"], [id="\${fieldName}"]`);

      // Handle specific case for state field
      if (!input && fieldName === 'state') {
        input = shadowRoot.querySelector('[id="arr-id-0.nvbf22lf4ar"]');
      }

      if (input) {
        if (input.tagName === 'SELECT') {
          // Handle dropdown/select fields
          const option = Array.from(input.options).find(opt => opt.value === value);
          if (option) {
            input.value = value;
            ['change', 'blur'].forEach(eventType => {
              input.dispatchEvent(new Event(eventType, { bubbles: true, composed: true }));
            });
            console.log(`Populated dropdown \${fieldName} with \${value}`);
          } else {
            console.warn(`Option with value "\${value}" not found for dropdown \${fieldName}`);
          }
        } else {
          // Handle other input types
          input.value = value;
          ['input', 'change', 'blur'].forEach(eventType => {
            input.dispatchEvent(new Event(eventType, { bubbles: true, composed: true }));
          });
          console.log(`Populated \${fieldName} with \${value}`);
        }
      } else {
        console.warn(`Field not found: \${fieldName}`);
      }
    });
  }

  function retryPopulation(retries = 5) {
    if (retries <= 0) {
      console.error('Failed to populate fields after multiple attempts');
      return;
    }

    populateFormFields();

    setTimeout(() => {
      retryPopulation(retries - 1);
    }, 500);
  }

  retryPopulation();

  new MutationObserver(mutations => {
    if (mutations.some(m => m.addedNodes.length > 0)) {
      populateFormFields();
    }
  }).observe(
    document.querySelector('array-account-enroll').shadowRoot,
    { childList: true, subtree: true }
  );
  ''';
  }

  static String _mapToJsObject(Map<String, String> map) {
    return '{${map.entries.map((e) => '"${e.key}": "${e.value}"').join(',')}}';
  }
}
