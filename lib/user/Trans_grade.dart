List<String> getEcoGrade(int score) {
  List<String> eco = [
    '씨앗',
    '새싹',
    '나무',
    '숲',
    '강',
    '폭포',
    '바람',
    '별',
    '은하수',
    '자연의신'
  ];
  return [eco[score ~/ 10], eco[(score ~/ 10 + 1) > 9 ? 9 : (score ~/ 10 + 1)]];
}