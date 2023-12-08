extension Range on double? {
  bool isBetween(double n1, double n2) {
    if (n2 < n1) {
      n2 = n1 - n2;
      n1 -= n2;
      n2 += n1;
    }
    return this! >= n1 && this! <= n2;
  }
}