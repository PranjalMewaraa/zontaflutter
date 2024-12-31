class FormFields {
  static const Map<String, String> firstPageFields = {
    'firstName': 'THOMAS',
    'lastName': 'DEVOS',
    'address': '1206 BEAR CREEK RD APT 110',
    'city': 'TUSCALOOSA',
    'state': 'AL',
    'zip': '35405',
  };

  static const Map<String, String> secondPageFields = {
    'full-date': '1957-09-06', // Updated to match yyyy-MM-dd format
    'ssn-initial-three': '666',
    'ssn-middle-two': '02',
    'ssn-final-four': '3511',
    'arr-id-0.8qnm5a4tsg':
        '4045049006', // Still needs identification in shadow DOM
    'email': 'tdevos@example.com'
  };
}
