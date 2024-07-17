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

class PasswordValidator {
  static String? validate(String value) {
    //Checking if password is empty
    if (value.isEmpty) {
      return 'Password required';
    }

    //Checking if the password has minimum 6 characters
    if (value.length < 6) {
      return 'Password must contain minimum 6 characters';
    }

    //Checking whether the password is having at least one digit
    if (!value.contains(RegExp(r'\d'))) {
      return 'Password must contain a numeric value';
    }

    //Check if the password contains any capital letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain minimum 1 uppercase letter';
    }

    //Check if the password contains any simple letters
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain minimum 1 lowercase letter';
    }

    //Check if the password contains any digits
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain minimum 1 numeric value';
    }

    //Check if the password contains any special characters
    if (!value.contains(RegExp(r'[!@#$%^&*()_+-]'))) {
      return 'Password must contain minimum 1 special character (!@#\$%^&*()_-+)';
    }

    return null;
  }
}

class RetypePasswordValidator {
  static String? validate(String value, String password) {
    //Checking if password is retyped
    if (value.isEmpty) {
      return 'Must Retype Password';
    }

    //Checking if passwords match
    if (!(value == password)) {
      return "Passwords doesn't match";
    }

    return null;
  }
}
