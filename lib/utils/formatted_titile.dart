String formattedTitle(String title) {
  String cleanedTitle = title;
  cleanedTitle = cleanedTitle.replaceAll(RegExp(r'\([^]*\)'), '');

  cleanedTitle = cleanedTitle.replaceAll(RegExp(r'\[[^\]]*\]'), '');

  if(cleanedTitle.contains('.')) {
    cleanedTitle = cleanedTitle.split('.').first;
  }

  return cleanedTitle;
}