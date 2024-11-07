extension StringExtensions on String {
  String replaceHtmlEntities() {
    return replaceAll('&#39;', "'") // &apos; ve &#39; -> '
        .replaceAll('&quot;', '"') // &quot; -> "
        .replaceAll('&amp;', '&') // &amp; -> &
        .replaceAll('&lt;', '<') // &lt; -> <
        .replaceAll('&gt;', '>') // &gt; -> >
        .replaceAll('&copy;', '©') // &copy; -> ©
        .replaceAll('&reg;', '®') // &reg; -> ®
        .replaceAll('&#160;', ' ') // &#160; -> Space
        .replaceAll('&#169;', '©') // &#169; -> ©
        .replaceAll('&#174;', '®') // &#174; -> ®
        .replaceAll('&#8364;', '€') // &#8364; -> €
        .replaceAll('&#163;', '£') // &#163; -> £
        .replaceAll('&#8369;', '₹') // &#8369; -> ₹
        .replaceAll('&#165;', '¥') // &#165; -> ¥
        .replaceAll('&#8211;', '–') // &#8211; -> –
        .replaceAll('&#8217;', '’') // &#8217; -> ’
        .replaceAll('&#8220;', '“') // &#8220; -> “
        .replaceAll('&#8221;', '”') // &#8221; -> ”
        .replaceAll('&#8230;', '…') // &#8230; -> …
        .replaceAll('&#160;', ' ') // nbsp; -> space
        .replaceAll('&#x2F;', '/') // &#x2F; -> /
        .replaceAll('&#x27;', "'") // &#x27; -> '
        .replaceAll(r"\\n", " ")
        .replaceAll("[", "(")
        .replaceAll("]", ")");
  }

  bool isYoutubeUrl() {
    return RegExp(
            r"^(https?://)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)/(watch\?v=|embed\/|v\/|e\/|shorts\/)[a-zA-Z0-9_-]{11}$")
        .hasMatch(this);
  }

  String get onlyLatin {
    if (isEmpty) return '';
    final regex = RegExp(r'[^a-zA-Z\s]+');
    return replaceAll(regex, '');
  }
}
