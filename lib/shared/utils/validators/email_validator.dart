
class EmailValidator {
  static bool isValid(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\$').hasMatch(email);
  }
}
