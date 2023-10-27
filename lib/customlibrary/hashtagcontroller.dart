import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//String text hashtag 지정
class HashTagText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  HashTagText({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: buildHashTagTextSpan(text, style),
      overflow: TextOverflow.visible, // 텍스트가 한 줄을 넘어가면 다음 줄로 이어집니다.
    );
  }
}

TextSpan buildHashTagTextSpan(String text, TextStyle? style) {
  List<TextSpan> spans = [];
  final regex = RegExp(r'#([\wㄱ-ㅎㅏ-ㅣ가-힣]+)');
  int lastMatchEnd = 0;

  regex.allMatches(text).forEach((match) {
    final hashtag = match.group(0);
    final start = match.start;
    final end = match.end;

    if (start > lastMatchEnd) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd, start)));
    }
    spans.add(TextSpan(
        text: hashtag, style: const TextStyle(color: Colors.indigo)));  // 해시태그 색상
    lastMatchEnd = end;
  });

  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(text: text.substring(lastMatchEnd)));  // 해시태그 이후의 텍스트를 추가합니다.
  }

  // 해시태그가 전혀 없는 경우
  if (spans.isEmpty) {
    spans.add(TextSpan(text: text));
  }

  return TextSpan(style: style, children: spans);
}



//textfield hashtag 지정
class HashtagEditingController extends TextEditingController {
  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      composing: TextRange.empty,
      selection:
      TextSelection.fromPosition(TextPosition(offset: newText.length)),
    );
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
        TextStyle? style,
        required bool withComposing}) {
    List<TextSpan> spans = [];
    final regex = RegExp(r'#([\wㄱ-ㅎㅏ-ㅣ가-힣]+)');
    String text = this.text;
    int lastMatchEnd = 0;

    regex.allMatches(text).forEach((match) {
      final hashtag = match.group(0);
      final start = match.start;
      final end = match.end;

      // Hashtag 이전의 텍스트를 추가
      if (start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, start)));
      }
      // Hashtag 자체를 추가
      spans.add(TextSpan(
          text: hashtag, style: const TextStyle(color: Colors.indigo))); // 해시태그 색상

      lastMatchEnd = end;
    });

    // 마지막 해시태그 이후의 텍스트를 추가
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return TextSpan(style: style, children: spans);
  }
}