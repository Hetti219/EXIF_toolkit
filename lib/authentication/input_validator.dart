class EmailValidator {
  static String? validate(String value) {
    //Checking if eMail is empty
    if (value.isEmpty) {
      return 'eMail required';
    }

    //Checking if the email is in proper format
    if (!RegExp(r'^[\w-.]+@([\w-.]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email address';
    }

    return null;
  }
}
