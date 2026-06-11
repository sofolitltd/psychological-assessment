bool isOnlyEnglish(String text) {
  return RegExp(r'^[a-zA-Z0-9\s\.\,\-\_\(\)\/\+\#]+$').hasMatch(text);
}
