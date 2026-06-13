extension BengaliDigits on int {
  String get bn {
    const digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return toString().split('').map((c) => digits[int.parse(c)]).join();
  }
}
