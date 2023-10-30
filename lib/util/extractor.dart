// use dart to extract chinese from text
String extractChinese(String? text) {
  if (text == null) return '';

  RegExp pattern = RegExp(r'[\u4e00-\u9fa5]+');
  Iterable<RegExpMatch> matches = pattern.allMatches(text);

  print(matches.join(','));

  return matches.join(',');
}
